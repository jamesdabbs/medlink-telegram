module Handlers
  class OutstandingOrders < Handler
    include ActionView::Helpers::DateHelper

    def applies?
      message.text.strip =~ /^(show|outstanding) orders$/i
    end

    def run
      orders = medlink.outstanding_orders
      unless orders.any?
        reply "You don't appear to have any outstanding orders."
        return
      end

      groups = orders.
        group_by { |o| time_ago_in_words o.placed_at }.
        sort_by  { |g, os| os.map(&:placed_at).min }

      groups.each do |ago, os|
        supplies = os.map { |o| "#{o.supply.shortcode} - #{o.supply.name}" }
        reply "From #{ago} ago<pre>#{supplies.join "\n"}</pre>", parse_mode: "html"
      end
    end
  end
end
