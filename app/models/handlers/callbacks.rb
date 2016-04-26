module Handlers
  class Callbacks < Handler
    def applies?
      message.is_a? Types::CallbackQuery
    end

    def run
      data = JSON.parse message.data
      key  = data.fetch "key" # TODO: what about other callback data
      handler = Bot.callback key
      call handler if handler # TODO: what if none match?
    end
  end
end
