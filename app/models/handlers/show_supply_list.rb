module Handlers
  class ShowSupplyList < Handler
    def applies?
      message.text =~ /^\/?list/i
    end

    def run
      response = medlink.available_supplies.map do |s|
        "#{s.shortcode} - #{s.name}"
      end.join "\n"

      reply "Here are the supplies currently available in your country:"
      reply "<pre>#{response}</pre>", parse_mode: "html"
    end
  end
end
