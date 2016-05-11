class Bot
  class Response
    attr_reader :messages, :handlers

    def initialize responder:
      @handlers, @messages = [], []
      @responder = responder
    end

    def reply request, text, **opts
      m = Bot::Response::Item.new text, **opts
      @messages.push m
      @responder.call request, m
    end
  end
end
