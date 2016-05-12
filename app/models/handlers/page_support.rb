module Handlers
  class PageSupport < Handler
    command :support

    def call c
      buttons = c.callbacks.buttons(
        expand_message_history: "See More",
        resolve_support: "Done!"
      )
      SupportNotifier.new.call c.user, buttons
      c.reply "Okay, I've paged @MedlinkSupport."
      c.reply "Unfortunately, we're unable to have support available 24-7, but we'll respond as soon as we can."
      c.reply "If you're calling about something urgent, please contact your PCMO directly."
    end
  end
end
