class Bot
  class Response
    attr_reader :messages

    def initialize telegram:
      @messages, @telegram = [], telegram
    end

    def reply request, text, markup: nil
      m = Bot::Response::Item.new text, markup: markup
      @messages.push m
      @telegram.reply_to request, message: m
    end
  end
end
