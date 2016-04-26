module Handlers
  class TakeOrder < Handler
    def applies?
      match.present?
    end

    def run finder: nil, placer: nil
      finder ||= SupplyFinder.new(medlink: medlink)
      result = finder.run parsed

      placer ||= OrderPlacer.new(medlink: medlink)
      placer.run result.recognized

      if placer.new_orders.any?
        desc = placer.new_orders.map(&:name).to_sentence
        reply "Alright! Your order for #{desc} is in the system. We'll get back to you ASAP."
      end
      if placer.pre_existing_orders.any?
        desc = placer.pre_existing_orders.to_sentence
        reply "You already had open orders for #{desc}, so I didn't update those. If you haven't gotten an item that you expect, please contact support@pcmedlink.org"
      end
      if placer.user_errors.any?
        # TODO: differentiate user and server errors here
        desc = placer.user_errors.to_sentence
        reply "Something went wrong when trying to order #{desc}."
      end
    end

    private

    def match
      message.text.match(/^\/?order(.*)/)
    end

    def parsed
      match[1].split(",").map(&:strip)
    end
  end
end
