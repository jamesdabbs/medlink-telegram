module Handlers
  class Dispatch
    def initialize handlers:, callbacks:
      @handlers  = handlers.map { |klass| klass.new self }
      @callbacks = callbacks
    end

    def call request, response, *args
      find(request).call request, response, *args
    end

    def find request
      match = handlers.find { |handler| handler.applies? request }
      match || self[Handlers::Fallback]
    end

    def [] klass
      handlers.find { |h| h.is_a? klass }
    end

    attr_reader :callbacks

    private

    attr_reader :handlers
  end
end
