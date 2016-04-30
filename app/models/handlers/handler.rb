module Handlers
  def self.find request, response, handlers: nil
    handlers.find do |klass|
      handler = klass.new request, response
      return handler if handler.applies?
    end

    fallback_handler.new request, response
  end

  def self.dispatch request, response, handlers:
    find(request, response, handlers: handlers).send :__run__
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
    end

    def reply text, **opts
      reply = Bot::Response::Item.new text, **opts
      response.messages.push reply
      Bot.reply_to request, reply.to_args
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
      # :nocov:
      raise NotImplementedError, "#{self.class} does not implement `run`"
      # :nocov:
    end

    private

    attr_reader :request

    def medlink
      @medlink ||= Medlink.new phone: user.phone_number
    end

    def call other
      other.new(request, response).send :__run__
    end

    def __run__
      response.handlers.push self
      run
      response
    end
  end
end
