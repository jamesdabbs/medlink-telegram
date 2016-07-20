module Handlers
  class TakeOrder < Handler
    def applies? request
      match(request.message).present?
    end

    def match message
      message.text.match(/^\/?order(.*)/)
    end

    def parsed message
      match(message)[1].split(",").map(&:strip)
    end

    def call c, finder: nil, placer: nil
      finder ||= SupplyFinder.new(medlink: c.medlink, user: c.sender)
      result = finder.run parsed(c.message)

      placer ||= OrderPlacer.new(medlink: c.medlink, user: c.sender)
      placer.run result.recognized

      if placer.new_orders.any?
        desc = placer.new_orders.map(&:name).to_sentence
        c.reply "Alright! Your order for #{desc} is in the system. We'll get back to you ASAP."
      end
      if placer.pre_existing_orders.any?
        desc = placer.pre_existing_orders.map(&:name).to_sentence
        c.reply "You already had open orders for #{desc}, so I didn't update those. If you haven't gotten an item that you expect, please contact support@pcmedlink.org"
      end
      if placer.user_errors.any?
        # TODO: differentiate user and server errors here
        desc = placer.user_errors.to_sentence
        c.reply "Something went wrong when trying to order #{desc}."
      end
    end
  end
end
