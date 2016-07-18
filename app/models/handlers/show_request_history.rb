module Handlers
  class ShowRequestHistory < Handler
    def call c
      c.reply "Here's your request history ..."
    end
  end
end
