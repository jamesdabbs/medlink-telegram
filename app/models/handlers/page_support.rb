module Handlers
  class PageSupport < Handler
    command :support

    def call c
      SupportNotifier.for(c.bot).call c.sender

      c.reply "Okay, I've paged @MedlinkSupport."
      c.reply "Unfortunately, we're unable to have support available 24-7, but we'll respond as soon as we can."
      c.reply "If you're asking about something urgent, please contact your PCMO directly."
    end
  end
end
