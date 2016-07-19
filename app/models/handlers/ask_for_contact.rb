module Handlers
  class AskForContact < Handler
    def applies? c
      !c.sender.registered?
    end

    def call c
      markup = Types::ReplyKeyboardMarkup.new keyboard: [
        Types::KeyboardButton.new(text: "Share phone number", request_contact: true)
      ]
      c.reply "Welcome to Medlink! We'll need your phone number to look you up.",
        markup: markup
    end
  end
end
