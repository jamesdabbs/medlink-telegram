module Handlers
  class ContinueOrder < Handler
    def applies?
      return false unless user.ordering?
      @finder = SupplyFinder.new(medlink: medlink)
      @finder.has_match? message.text
    end

    def run
      # TODO: batch these up and send when the user is done?
      if m = @finder.near_match(message.text)
        medlink.new_order supplies: [m]
        reply "Requested #{m.name}. Anything else?"
      else
        suggestions = @finder.suggestions(message.text).map do |s|
          "#{s.shortcode} - #{s.name}"
        end.join "\n"

        reply "I'm not entirely sure what '#{message.text}' is. Did you mean one of the following?<pre>#{no}</pre>", parse_mode: "html"

        # TODO: what if the user replies "no"?
      end
    end
  end
end
