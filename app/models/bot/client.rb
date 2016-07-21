class Bot
  class Client < Medlink.struct(:api, :get_chat, :sender)
    def self.build
      t = Telegram::Bot::Client.new Figaro.env.telegram_token!
      new \
        api:      t.api,
        get_chat: ->(chat_id:)           { t.api.get_chat chat_id: chat_id },
        sender:   ->(chat_id:, message:) { t.api.send_message message.to_args.merge(chat_id: chat_id) }
    end

    def reply_to request, message
      message chat_id: request.chat_id, message: message
    end

    def deliver to, message
      chat_id = if to.respond_to?(:telegram_id)
        to.telegram_id
      else
        Channel.by_name(to).chat_id
      end
      message chat_id: chat_id, message: message
    end

    def get_username chat_id:
      get_chat.call(chat_id: chat_id).fetch("result").fetch("username")
    end

    def inspect
      # :nocov:
      %|<#{self.class.name}>|
      # :nocov:
    end

    private

    def message chat_id:, message:
      sender.call chat_id: chat_id, message: message
    rescue Telegram::Bot::Exceptions::ResponseError => e
      # TODO: these errors should probably just go to support; it's unlikely that they'll
      # mean anything to end users
      raise e unless e.message.include? "Bad Request: Message text is empty"
    end
  end
end
