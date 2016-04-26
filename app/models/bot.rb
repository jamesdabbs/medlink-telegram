class Bot
  Client = Telegram::Bot::Client.new Figaro.env.telegram_token!

  def self.default_handlers
    [
      Handlers::Callbacks,
      Handlers::Start,
      Handlers::Help,
      Handlers::Settings,
      Handlers::RegisterContact,
      Handlers::AskForContact,

      Handlers::ShowSupplyList,
      Handlers::OutstandingOrders,

      # Multi-message state-based order flow
      Handlers::StartOrder,
      Handlers::ContinueOrder,
      Handlers::FinishOrder,

      # All-in-one order handler
      Handlers::TakeOrder,

      Handlers::Fallback
    ]
  end

  def self.receive message
    request = Request.new message
    new(request: request).handle
  end

  def self.run
    Telegram::Bot::Client.run Figaro.env.telegram_token! do |b|
      b.listen { |message| receive message }
    end
  end

  def self.reply_to request, text, **opts
    return if Rails.env.test? # FIXME

    message = request.message
    chat_id = if message.respond_to?(:chat)
      message.chat.id
    else # FIXME
      message.message.chat.id
    end

    Bot::Client.api.send_message opts.merge chat_id: chat_id, text: text
  end

  def self.register_callback name, klass
    @callbacks ||= {}
    @callbacks[name.to_sym] = klass
  end

  def self.callback data
    @callbacks ||= {}
    @callbacks[data.to_sym]
  end

  def self.callback_data buttons
    buttons.map do |key, label|
      raise "Callback not registered: #{key}" unless callback(key)
      { text: label, callback_data: { key: key }.to_json }
    end
  end

  # N.B. need to register these here for development-mode loading to work
  register_callback :show_request_history, Handlers::ShowRequestHistory
  register_callback :show_supply_list, Handlers::ShowSupplyList
  register_callback :show_outstanding_orders, Handlers::OutstandingOrders
  register_callback :start_new_order, Handlers::StartOrder

  def handle request
    receipt = record_receipt request: request

    response = Handlers.dispatch request, handlers: handlers
    if response.error
      receipt.update! handled: false, error: serialize_error(response.error)
      Bot.reply_to request, "Uh-oh. Looks like something went wrong: #{response.error}"
    elsif response.handled?
      receipt.update! handled: true, response: response.messages
    else
      receipt.update! handled: false, response: response.messages
    end

    response
  rescue StandardError => e
    # TODO: what if something goes wrong here?
    receipt.try :update!, error: serialize_error(e)
    Bot.reply_to request, "Uh-oh. Looks like something went wrong: #{e}"
  end

  private

  attr_reader :handlers

  def initialize handlers: nil
    @handlers = handlers || self.class.default_handlers
  end

  def serialize_error e
    {
      message:  e.to_s,
      location: e.backtrace.reject { |l| l.include?('ruby/gem') }.first(5)
    }
  end

  def record_receipt request:
    Message.create!(raw: request.message.to_h)
  end
end
