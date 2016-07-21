module Handlers
  class Error < Handler
    def call c, error
      Rollbar.error error
      c.reply "Uh-oh, something went wrong. I've paged support, and they'll get back to you ASAP."
      c.send :support, html_escape("Error when handling #{c.message.inspect}: #{error}")
    end
  end
end
