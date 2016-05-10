module Telegram::Bot::Types
  class Message
    def inspect
      %|<Telegram::Message("#{text}")>|
    end
  end
end
