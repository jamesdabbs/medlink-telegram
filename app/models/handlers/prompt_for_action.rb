module Handlers
  class PromptForAction < Handler
    def call c
      buttons = c.callbacks.buttons(
        start_new_order:         "Place a New Order",
        show_outstanding_orders: "Show My Outstanding Orders",
        show_supply_list:        "List Available Supplies"
      ).map { |d| Types::InlineKeyboardButton.new d }

      markup = Types::InlineKeyboardMarkup.new inline_keyboard: buttons
      c.reply "What can I do for you, #{c.user.first_name}?", reply_markup: markup
    end
  end
end
