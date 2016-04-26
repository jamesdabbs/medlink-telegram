module Handlers
  class Help < Handler
    def applies?
      message.text =~ /^\/?help/i
    end

    def run
      call PromptForAction
      reply "If none of those are what you're looking for, please email support@pcmedlink.org to talk to a human."
    end
  end
end
