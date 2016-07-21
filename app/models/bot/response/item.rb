class Bot
  class Response
    class Item
      attr_reader :text, :markup

      def initialize text, markup: nil
        @text, @markup = text, markup
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
        markup.inline_keyboard ? markup.inline_keyboard.map { |a| a.first.text } : []
      end

      def keyboard
        markup.keyboard
      end

      def to_args
        opts = {
          parse_mode: "html",
          text:       text
        }
        opts[:reply_markup] = markup if markup
        opts
      end

      def inspect
        # :nocov:
        %|<#{self.class.name}("#{text}", buttons: #{buttons})>|
        # :nocov:
      end
    end
  end
end
