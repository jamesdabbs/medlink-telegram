module Handlers
  class Help < Handler
    match /^\/?help/i

    run do
      run PromptForAction
      reply "If none of those are what you're looking for, please email support@pcmedlink.org to talk to a human."
    end
  end
end
