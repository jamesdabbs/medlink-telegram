module Handlers
  class ContinueOrder < Handler
    def applies? c
      return false unless c.sender.ordering?
      supply_finder(c).has_match? c.message.text
    end

    def supply_finder c
      SupplyFinder.new(medlink: c.medlink)
    end

    def call c
      finder = supply_finder c
      # TODO: batch these up and send when the user is done?
      if m = finder.near_match(c.message.text)
        c.medlink.new_order supplies: [m]
        c.reply "Requested #{m.name}. Anything else?"
      else
        suggestions = finder.suggestions(c.message.text).map do |s|
          "#{s.shortcode} - #{s.name}"
        end.join "\n"

        c.reply "I'm not entirely sure what '#{c.message.text}' is. Did you mean one of the following?<pre>#{suggestions}</pre>"

        # TODO: what if the user replies "no"?
      end
    end
  end
end
