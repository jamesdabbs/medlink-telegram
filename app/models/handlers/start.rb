module Handlers
  class Start < Handler
    command :start

    def call c
      if c.sender.registered?
        c.reply "Welcome back!"
        c.call PromptForAction
      else
        c.call AskForContact
      end
    end
  end
end
