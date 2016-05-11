module Handlers
  class Callbacks < Handler
    def applies? request
      request.message.is_a? Types::CallbackQuery
    end

    def call c
      # TODO: what about other callback data
      key     = JSON.parse(c.message.data).fetch "key"
      handler = c.callbacks[key]
      c.call handler if handler # TODO: what if none match?
    end
  end
end
