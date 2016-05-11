class Bot
  class Client
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
        messages.push opts
      else
        @client.send_message **opts
      end
    end

    def messages
      @messages ||= []
    end
  end
end
