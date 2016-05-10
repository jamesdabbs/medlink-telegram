module Handlers
  class Delegate
    extend Forwardable
    def_delegators :@request, :message, :user, :medlink

    def initialize dispatch:, request:, response:
      @dispatch, @request, @response = dispatch, request, response
    end

    private

    attr_reader :request, :response, :dispatch

    def reply text, **opts
      response.reply request, text, **opts
    end

    def run other, *args
      h = dispatch[other] || other.new(dispatch)
      h.call request, response
    end

    def callbacks
      dispatch.callbacks
    end
  end


  class Handler
    Types = Telegram::Bot::Types

    def initialize dispatch
      @dispatch = dispatch
    end

    def call request, response, *args
      raise "#{self.class} should define a `run` block" unless self.class.runner
      response.handlers.push self
      Delegate.new(
        dispatch:  dispatch,
        request:   request,
        response:  response
      ).instance_exec(*args, &self.class.runner)
      response
    end

    def applies? request
      if self.class.match
        request.message.text && request.message.text.strip =~ self.class.match
      else
        false
      end
    end

    def self.match exp=nil
      exp ? @match = exp : @match
    end

    def self.run &runner
      @runner = runner
    end

    def self.runner
      @runner
    end

    def inspect
      # :nocov:
      "<#{self.class}>"
      # :nocov:
    end

    private

    attr_reader :dispatch
  end
end
