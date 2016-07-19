module Handlers
  class CheckDelivery < Handler
    include ActionView::Helpers::DateHelper

    def call c, response:, user:
      supplies = response.shipped_supplies.map &:name

      if supplies.empty?
        Rails.logger.info "Not prompting for empty supplies"
        return
      end

      c.send user, %|
        Have you received your order for #{supplies.to_sentence}, placed
        #{time_ago_in_words response.created_at} ago?
      |.squish
    end
  end
end
