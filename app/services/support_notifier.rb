class SupportNotifier < Medlink.struct(:telegram, :callbacks)
  def self.for bot
    new telegram: bot.telegram, callbacks: bot.dispatch.callbacks
  end

  def call user
    user.needs_help!
    telegram.message_support intro(user)

    keyboard = Handlers::Handler::Types::InlineKeyboardMarkup.new inline_keyboard: [
      callbacks.button(:expand_message_history, "See More"),
      callbacks.button(:resolve_support, "Done!", user_id: user.id)
    ]
    telegram.message_support history(user), markup: keyboard
  end

  private

  attr_reader :client

  def intro user
    "#{user.name} (@#{user.telegram_username} / ##{user.id}) needs some help"
  end

  def history user
    user.receipts.newest(10).map { |r| r.request.text }.join("\n")
  end
end
