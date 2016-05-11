module Handlers
  class Context
    attr_reader :request, :response, :handlers, :medlink
    attr_accessor :error

    def initialize request, response, dispatch, medlink: nil
      @request, @response, @dispatch = request, response, dispatch
      @handlers = []
      @medlink  = medlink
    end

    def call handler, *args
      # This is a HACK to get "redirection" to work as intented
      handler = dispatch[handler] if handler.is_a?(Class)

      handlers.push handler
      handler.call self, *args
      self
    end

    def message; request.message; end
    def user;    request.user;    end

    def reply text, **opts
      response.reply request, text, **opts
    end

    def callbacks
      dispatch.callbacks
    end

    def medlink
      @medlink ||= Medlink.for_phone(user.try :phone_number)
    end

    def handled?
      handlers.none? { |h| h.is_a? Handlers::Fallback }
    end

    private

    attr_reader :dispatch
  end
end
