module Handlers
  class AskForContact < Handler
    def applies?
      user.nil?
    end

    def run
      kb = [
        Types::KeyboardButton.new(text: "Share phone number", request_contact: true)
      ]
      markup = Types::ReplyKeyboardMarkup.new(keyboard: kb)
      reply "Welcome to Medlink! We'll need your phone number to look you up.",
            reply_markup: markup
    end
  end
end
