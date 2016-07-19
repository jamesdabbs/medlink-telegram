module Handlers
  class Dispatch
    def self.build handlers:, callbacks:
      new handlers: handlers, callbacks: CallbackRegistry.build(callbacks)
    end

    def initialize handlers:, callbacks:
      # N.B. Handlers are assumed to be state-free, so this klass => instance
      #   cache should be fine
      @handlers = {}
      handlers.each { |klass| register_handler klass }
      @callbacks = callbacks
    end

    def call context
      case context.message
      when Message
        context.call find context
      when Callback
        klass = callbacks.fetch context.message.key
        context.message.data.any? ? self[klass].call(context, **context.message.data) : self[klass].call(context)
      else
        raise "Can't route #{context.message}"
      end
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
