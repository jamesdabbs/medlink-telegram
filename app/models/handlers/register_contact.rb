module Handlers
  class RegisterContact < Handler
    def applies? request
      !request.user && request.message.contact
    end

    def call c
      if User.register_from_contact(c.message.contact)
        kb = Types::ReplyKeyboardHide.new(text: "", hide_keyboard: true)
        c.reply "Awesome, got it!", reply_markup: kb

        c.call PromptForAction
      else
        c.reply "Hrm. It looks like we couldn't find your number in the system. Is there another number you use?"
      end
    end
  end
end
