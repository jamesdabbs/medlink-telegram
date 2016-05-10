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

      def markup
        @opts[:reply_markup]
      end

      def buttons
        markup.inline_keyboard.map { |a| a.first.text }
      rescue
        []
      end

      def keyboard
        markup.keyboard
      end

      def to_args
        @opts.merge text: text
      end

      def inspect
        %|<#{self.class.name}("#{text}", buttons: #{buttons})>|
      end
    end
  end
end
