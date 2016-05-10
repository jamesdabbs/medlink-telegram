module Handlers
  class Fallback < Handler
    def applies? request
      true
    end

    run do
      reply "I'm really sorry, but I don't know what you're saying."
      reply "I'm getting smarter all the time, but I am still just a robot. If you ever need to talk to a human, please email support@pcmedlink.org."
    end
  end
end
