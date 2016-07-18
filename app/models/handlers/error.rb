module Handlers
  class Error < Handler
    def call c, error
      Rollbar.error error
      c.reply "Uh-oh. Looks like something went wrong: #{error}"
    end
  end
end
