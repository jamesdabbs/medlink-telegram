class Bot
  def call request
    recorder.call request, responder do |response|
      dispatch.call request, response
    end
  end

  def receive update:
    request = Request.new update.message || update.callback.query
    handle request: request
  end

  def handle request:
    call request
  end

  attr_reader :recorder, :dispatch, :responder

  private

  def initialize recorder:, dispatch:, responder:
    @recorder, @dispatch, @responder = recorder, dispatch, responder
  end
end
