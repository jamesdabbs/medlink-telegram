module Handlers
  class Help < Handler
    command :help

    def call c
      c.call PromptForAction
      c.reply %|If none of those are what you're looking for, you can say "support" at any time to page a human|
    end
  end
end
