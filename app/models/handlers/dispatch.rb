module Handlers
  class Dispatch
    def initialize handlers:, callbacks:
      # N.B. Handlers are assumed to be state-free, so this klass => instance
      #   cache should be fine
      @handlers = {}
      handlers.each { |klass| register_handler klass }
      @callbacks = callbacks
    end

    def call context
      context.call find context
    end

    def find context
      match = handlers.find { |_, handler| handler.applies? context }
      if match
        match.last
      else
        self[Handlers::Fallback]
      end
    end

    def [] klass
      handlers[klass] || register_handler(klass)
    end

    attr_reader :callbacks

    def inspect
      # :nocov:
      "<#{self.class.name}(handlers: #{handlers.keys}, callbacks: #{callbacks.inspect})>"
      # :nocov:
    end

    private

    attr_reader :handlers

    def register_handler klass
      handlers[klass] = klass.new(self).tap(&:freeze)
    end
  end
end
