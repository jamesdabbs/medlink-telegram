class Bot
  class Client < Medlink.struct(:sender)
    def self.build
      t = Telegram::Bot::Client.new Figaro.env.telegram_token!
      new sender: ->(opts) { t.api.send_message opts }
    end

    def reply_to request, message:
      message reply_routing_keys(request).merge message: message
    end

    def message msg
      sender.call msg
    end

    def message_support text, markup: nil
      message(
        chat_id: User.support.telegram_id,
        message: Bot::Response::Item.new(text, markup: markup)
      )
    end

    def inspect
      # :nocov:
      %|<#{self.class.name}>|
      # :nocov:
    end

    private

    def reply_routing_keys request
      if request.try :chat
        { chat_id: request.chat.id }
      elsif request.try(:message).try :chat
        { chat_id: request.message.chat.id }
      else
        raise "Don't know how to reply to #{request}"
      end
    end

  end
end
