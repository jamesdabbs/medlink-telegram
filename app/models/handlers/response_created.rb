module Handlers
  class ResponseCreated < Handler
    def call c, response:, user:
      supplies = response.supplies.map { |s| "* #{s.name} #{s.status}" }

      c.send user, <<~MSG
        Your order has been processed
        #{supplies.join "\n"}
        #{response.extra_information}
      MSG
    end
  end
end
