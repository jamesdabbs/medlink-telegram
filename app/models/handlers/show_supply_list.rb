module Handlers
  class ShowSupplyList < Handler
    match /^\/?list/i

    def call c
      response = c.medlink.available_supplies.map do |s|
        "#{s.shortcode} - #{s.name}"
      end.join "\n"

      c.reply "Here are the supplies currently available in your country:"
      c.reply "<pre>#{response}</pre>", parse_mode: "html"
    end
  end
end
