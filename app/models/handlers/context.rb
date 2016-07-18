require "medlink/struct"

module Handlers
  class Context
    attr_reader :bot, :message, :response

    def initialize bot:, message:, response:, user: nil, medlink: nil
      @bot, @message, @response = bot, message, response
      @user, @medlink, @handlers = user, medlink, []
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

    def callbacks
      dispatch.callbacks
    end

    def callback key
      callback_data.fetch key.to_s
    end

    def handled?
      handlers.none? { |h| h.is_a? Handlers::Fallback }
    end

    def user
      @user ||= User.by_telegram_id message.from.id
    end

    def medlink
      @medlink ||= Medlink.for_phone user.try :phone_number
    end

    private

    attr_reader :handlers

    def dispatch
      bot.dispatch
    end

    def callback_data
      unless message.is_a? Telegram::Bot::Types::CallbackQuery
        raise "Tried to get callback data from #{message}"
      end

      @callback_data ||= JSON.parse(message.data)
    end
  end
end
