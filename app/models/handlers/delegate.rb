module Handlers
  class Delegate < SimpleDelegator
    def initialize handler, dispatch:, request:, response:
      __setobj__ handler
      @dispatch, @request, @response = dispatch, request, response
    end

    private

    attr_reader :request, :response, :dispatch

    def message; request.message; end
    def user;    request.user;    end
    def medlink; request.medlink; end

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
end
