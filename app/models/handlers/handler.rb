module Handlers
  class Handler
    Types = Telegram::Bot::Types

    def initialize dispatch
      @dispatch = dispatch
    end

    def applies? request
      if self.class.match
        request.message.text && request.message.text.strip =~ self.class.match
      else
        false
      end
    end

    def self.match exp=nil
      exp ? @match = exp : @match
    end

    def inspect
      # :nocov:
      "<#{self.class}>"
      # :nocov:
    end

    private

    attr_reader :dispatch
  end
end
