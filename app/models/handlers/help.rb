module Handlers
  class Help < Handler
    match /^\/?help/i

    def call c
      c.call PromptForAction
      c.reply "If none of those are what you're looking for, please email support@pcmedlink.org to talk to a human."
    end
  end
end
