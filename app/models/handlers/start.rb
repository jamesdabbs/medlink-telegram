module Handlers
  class Start < Handler
    match /^\/?start/i

    def call c
      if c.user
        c.reply "Welcome back!"
        c.call PromptForAction
      else
        c.call AskForContact
      end
    end
  end
end
