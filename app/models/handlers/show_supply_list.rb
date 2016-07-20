module Handlers
  class ShowSupplyList < Handler
    command :list

    def call c
      response = c.medlink.available_supplies(credentials: c.sender.credentials).map do |s|
        "#{s.shortcode} - #{s.name}"
      end.join "\n"

      c.reply "Here are the supplies currently available in your country:"
      c.reply "<pre>#{response}</pre>"
    end
  end
end
