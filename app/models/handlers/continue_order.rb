module Handlers
  class ContinueOrder < Handler
    def applies? request
      return false unless request.user.ordering?
      finder = SupplyFinder.new(medlink: request.medlink)
      finder.has_match? request.message.text
    end

    run do
      finder = SupplyFinder.new(medlink: request.medlink)
      finder.has_match? request.message.text

      # TODO: batch these up and send when the user is done?
      if m = finder.near_match(message.text)
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
