module Handlers
  class StartOrder < Handler
    def call c
      c.sender.update! ordering: true
      c.reply "Alright - what can I get for you?"
      c.reply %|Say "list" to see the list of available supplies, or say "done" when you're all finished.|
    end
  end
end
