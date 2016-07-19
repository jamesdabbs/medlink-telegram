require "medlink/struct"

module Handlers
  class Context
    attr_reader :bot, :message, :response

    def initialize bot:, message:, response:, sender: nil, medlink: nil
      @bot, @message, @response = bot, message, response
      @sender, @medlink, @handlers = sender, medlink, []
    end

    def call handler, *args
      handler = dispatch[handler] if handler.is_a?(Class)

      handlers.push handler
      handler.call self, *args
      self
    end

    def reply text, markup: nil
      response.reply message, text, markup: markup
    end

    def send user, text, markup: nil
      response.send user, text, markup: markup
    end

    def handled?
      handlers.none? { |h| h.is_a? Handlers::Fallback }
    end

    def sender
      return unless message.sender_id
      @sender ||= User.by_telegram_id message.sender_id
    end

    def medlink
      @medlink ||= Medlink.for_phone sender.try :phone_number
    end

    private

    attr_reader :handlers

    def dispatch
      bot.dispatch
    end
  end
end
