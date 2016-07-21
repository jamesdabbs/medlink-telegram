class Bot
  class Response
    attr_reader :messages

    def initialize telegram:
      @messages, @telegram = [], telegram
    end

    def reply request, text, markup: nil
      @telegram.reply_to request, make_message(text, markup: markup)
    end

    def send to, text, markup: nil
      @telegram.deliver to, make_message(text, markup: markup)
    end

    private

    def make_message text, markup:
      Bot::Response::Item.new(text, markup: markup).tap { |m| @messages.push m }
    end
  end
end
