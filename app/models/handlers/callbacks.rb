module Handlers
  class Callbacks < Handler
    def applies? request
      request.message.is_a? Types::CallbackQuery
    end

    run do
      # TODO: what about other callback data
      key     = JSON.parse(message.data).fetch "key"
      handler = callbacks[key]
      run handler if handler # TODO: what if none match?
    end
  end
end
