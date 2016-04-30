class Bot
  class Response
    class Item
      attr_reader :text

      def initialize text, **opts
        @text, @opts = text, opts
        freeze
      end

      def == other
        if other.is_a?(String)
          text == other
        else
          super
        end
      end

      def buttons
        @opts[:reply_markup].inline_keyboard.map { |a| a.first.text }
      end

      def keyboard
        @opts[:reply_markup].keyboard
      end

      def to_args
        @opts.merge text: text
      end
    end
  end
end
