class Bot
  class Request
    attr_reader :message

    def initialize message, user: nil
      @message, @user = message, user
    end

    def user
      @user ||= User.find_by(telegram_id: message.from.id)
    end

    class Test
      attr_accessor :user
      attr_writer :message, :medlink

      def message
        @message || raise("No message set")
      end
    end
  end
end
