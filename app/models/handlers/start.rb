module Handlers
  class Start < Handler
    match /^\/?start/i

    def run
      if user
        reply "Welcome back!"
        call PromptForAction
      else
        call AskForContact
      end
    end
  end
end
