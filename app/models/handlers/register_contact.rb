module Handlers
  class RegisterContact < Handler
    def applies? request
      !request.user && request.message.contact
    end

    run do
      if User.register_from_contact(message.contact)
        kb = Types::ReplyKeyboardHide.new(text: "", hide_keyboard: true)
        reply "Awesome, got it!", reply_markup: kb

        run PromptForAction
      else
        reply "Hrm. It looks like we couldn't find your number in the system. Is there another number you use?"
      end
    end
  end
end
