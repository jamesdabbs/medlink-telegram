class Bot
  class Client
    SUPPORT_ID = :support

    def self.build
      new Figaro.env.telegram_token!
    end

    def initialize token
      @api = Telegram::Bot::Client.new(token).api
    end

    def reply_to request, **opts
      message reply_routing_keys(request).merge opts
    end

    def reply_routing_keys request
      if request.try :chat
        { chat_id: request.chat.id }
      elsif request.try(:message).try :chat
        { chat_id: request.message.chat.id }
      else
        raise "Don't know how to reply to #{request}"
      end
    end

    def message **opts
      if Rails.env.test?
        messages[opts[:chat_id]] ||= []
        messages[opts[:chat_id]].push opts
      else
        api.send_message **opts
      end
    end

    def message_support text, **opts
      opts[:text]    = text
      opts[:chat_id] = SUPPORT_ID

      if Rails.env.test?
        messages[:support] ||= []
        messages[:support].push opts
      else
        api.send_message **opts
      end
    end

    def messages
      @messages ||= {}
    end

    private

    attr_reader :api
  end
end
