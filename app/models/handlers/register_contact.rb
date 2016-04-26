module Handlers
  class RegisterContact < Handler
    def applies?
      !user && message.contact
    end

    def run
      if user = User.register_from_contact(message.contact)
        kb = Types::ReplyKeyboardHide.new(text: "", hide_keyboard: true)
        reply "Awesome, got it!", reply_markup: kb

        call PromptForAction
      else
        reply "Hrm. It looks like we couldn't find your number in the system. Is there another number you use?"
      end
    end
  end
end
