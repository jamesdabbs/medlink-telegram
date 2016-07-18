module Handlers
  class Callbacks < Handler
    def applies? c
      c.message.is_a? Types::CallbackQuery
    end

    def call c
      # TODO: what about other callback data
      data    = JSON.parse(c.message.data)
      key     = data.fetch "key"
      handler = c.callbacks[key]
      c.call handler if handler # TODO: what if none match?
    end
  end
end
