class Bot
  class Response
    attr_reader :handlers, :messages, :medlink

    def initialize medlink: nil
      @handlers, @messages = [], []
      @medlink = medlink
    end

    def handled?
      @handlers.none? { |h| h.is_a? Handlers.fallback_handler }
    end
  end
end
