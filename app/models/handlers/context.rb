module Handlers
  class Context
    attr_reader :message, :response
    attr_accessor :error

    def initialize message, response, dispatch, medlink: nil, user: nil
      @message, @response, @dispatch = message, response, dispatch
      # The `freeze` is a good sanity check, but doesn't work in test,
      #   where `@message` is often a double
      @message.freeze

      @handlers = []
      @medlink, @user = medlink, user
    end

    def call handler, *args
      handler = dispatch[handler] if handler.is_a?(Class)

      handlers.push handler
      handler.call self, *args
      self
    end

    def reply text, **opts
      response.reply message, text, **opts
    end

    def callbacks
      dispatch.callbacks
    end

    # N.B. this method is called _before_ we save a receipt,
    #   so it needs to be bullet-proof
    def user
      @user ||= User.by_telegram_id message.from.id
    end

    def medlink
      @medlink ||= Medlink.for_phone user.try :phone_number
    end

    def handled?
      handlers.none? { |h| h.is_a? Handlers::Fallback }
    end

    private

    attr_reader :dispatch, :handlers
  end
end
