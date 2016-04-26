module Handlers
  class StartOrder < Handler
    def run
      user.update! ordering: true
      reply "Alright - what can I get for you?"
      reply %|Say "list" to see the list of available supplies, or say "done" when you're all finished.|
    end
  end
end
