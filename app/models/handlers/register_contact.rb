module Handlers
  class RegisterContact < Handler
    def applies? c
      c.message.contact
    end

    def call c
      c.user.attach contact: c.message.contact

      if c.user.medlinked?
        kb = Types::ReplyKeyboardHide.new(text: "", hide_keyboard: true)
        c.reply "Awesome, got it!", reply_markup: kb

        c.call PromptForAction
      else
        c.call PageSupport
      end
    end
  end
end
