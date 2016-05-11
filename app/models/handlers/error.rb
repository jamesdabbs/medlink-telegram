module Handlers
  class Error < Handler
    def call c
      Rollbar.error c.error
      c.reply "Uh-oh. Looks like something went wrong: #{c.error}"
    end
  end
end
