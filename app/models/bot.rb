class Bot
  Client = Telegram::Bot::Client.new Figaro.env.telegram_token!

  def self.reply_to request, **opts
    message reply_routing_keys(request).merge opts
  end

  def self.reply_routing_keys request
    message = request.message
    if message.try :chat
      { chat_id: message.chat.id }
    elsif message.try(:message).try :chat
      { chat_id: message.message.chat.id }
    else
      raise "Don't know how to reply to #{request}"
    end
  end

  def self.message **opts
    if Rails.env.test?
      messages.push opts
    else
      Bot::Client.api.send_message **opts
    end
  end

  def self.messages
    @messages ||= []
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

  attr_reader :handlers, :error_handler

  def receive update:
    request = Request.new update.message || update.callback.query
    handle request: request
  end

  def handle request:
    ResponseRecorder.new(request, error_handler: error_handler).call do |response|
      Handlers.dispatch request, response, handlers: handlers
    end
  end

  private

  def initialize handlers:, error_handler: nil
    @handlers, @error_handler = handlers, error_handler
  end
end
