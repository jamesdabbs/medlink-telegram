module Handlers
  class Start < Handler
    match /^\/?start/i

    run do
      if user
        reply "Welcome back!"
        run PromptForAction
      else
        run AskForContact
      end
    end
  end
end
