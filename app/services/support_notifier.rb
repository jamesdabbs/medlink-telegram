class SupportNotifier < Medlink.struct(:telegram, :callbacks)
  def self.for bot
    new telegram: bot.telegram, callbacks: bot.dispatch.callbacks
  end

  def call user:, response:
    user.needs_help!
    response.send :support, intro(user)
    response.send :support, history(user), markup: keyboard(user)
  end

  private

  attr_reader :client

  def intro user
    "#{user.name} (@#{user.telegram_username} / ##{user.id}) needs some help"
  end

  def history user
    <<~MSG
      Here are their most recent messages:
      #{user.receipts.newest(10).map { |r| r.request.text }.join("\n")}
    MSG
  end

  def keyboard user
    Handlers::Handler::Types::InlineKeyboardMarkup.new inline_keyboard: [
      callbacks.button(:expand_message_history, "See More"),
      callbacks.button(:resolve_support, "Done!", user_id: user.id)
    ]
  end
end
