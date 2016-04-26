module Handlers
  def self.find request, handlers: nil
    response = Bot::Response.new

    handlers.find do |klass|
      handler = klass.new request, response
      return handler if handler.applies?
    end

    fallback_handler.new request, response
  end

  def self.dispatch request, handlers:
    handler = find request, handlers: handlers

    begin
      handler.run
    rescue StandardError => e
      handler.response.error = e
    end

    handler.response
  end

  def self.fallback_handler
    Handlers::Fallback
  end

  class Handler
    Types = Telegram::Bot::Types

    extend Forwardable
    def_delegators :@request, :user, :message

    attr_reader :response

    def initialize request, response, medlink: nil
      @request, @response = request, response
      @medlink = medlink
      @response.handler = self
    end

    def reply text, **opts
      reply = Bot::Response::Item.new text, **opts
      @response.messages.push reply
      unless Rails.env.test?
        Bot.reply_to request, *reply.to_args
      end
    end

    def applies?
      if self.class.match
        message.text && message.text.strip =~ self.class.match
      else
        false
      end
    end

    def self.match exp=nil
      exp ? @match = exp : @match
    end

    def run
      raise NotImplementedError, "#{self.class} does not implement `run`"
    end

    private

    attr_reader :request

    def medlink
      @medlink ||= Medlink.new phone: user.phone_number
    end

    def call other
      other.new(request, response).run
    end
  end
end
