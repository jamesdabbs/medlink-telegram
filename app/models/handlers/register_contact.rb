module Handlers
  class RegisterContact < Handler
    def applies? c
      c.message.contact
    end

    def call c
      ContactRegisterer.for(bot: c.bot).call \
        user: c.sender, contact: c.message.contact

      if c.sender.reload.medlinked?
        kb = Types::ReplyKeyboardHide.new(text: "", hide_keyboard: true)
        c.reply "Awesome, got it!", markup: kb

        c.call PromptForAction
      else
        SupportNotifier.for(c.bot).call user: c.sender, response: c.response

        c.reply "It looks like your Telegram phone number doesn't match the number attached to your Medlink account."
        c.reply "Unfortunately, that means that I can't help you without paging a human, but I've notified @MedlinkSupport and someone should be reaching out to you as soon as possible."
        c.reply "If you're asking about something urgent, please contact your PCMO directly."
      end
    end
  end
end
