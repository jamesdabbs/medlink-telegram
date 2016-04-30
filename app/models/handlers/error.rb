module Handlers
  class Error < Handler
    def run error
      Rollbar.error error
      reply "Uh-oh. Looks like something went wrong: #{error}"
    end
  end
end
