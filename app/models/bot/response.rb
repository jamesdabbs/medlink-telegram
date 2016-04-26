class Bot
  class Response
    attr_reader :messages, :medlink
    attr_accessor :error, :handler

    def initialize medlink: nil
      @messages = []
      @medlink = medlink
    end

    def handled?
      @handler && !@handler.is_a?(Handlers.fallback_handler)
    end
  end
end
