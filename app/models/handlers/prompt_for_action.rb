module Handlers
  class PromptForAction < Handler
    def call c
      markup = button_markup(
        start_new_order:         "Place a New Order",
        show_outstanding_orders: "Show My Outstanding Orders",
        show_supply_list:        "List Available Supplies"
      )
      c.reply "What can I do for you, #{c.user.first_name}?", markup: markup
    end
  end
end
