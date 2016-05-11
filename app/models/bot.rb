class Bot
  def call request, **opts
    response = Bot::Response.new responder: responder
    context  = Handlers::Context.new request, response, dispatch, **opts

    recorder.call context do
      dispatch.call context
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

  def with **opts
    self.class.new(
      recorder:  opts[:recorder]  || recorder,
      dispatch:  opts[:dispatch]  || dispatch,
      responder: opts[:responder] || responder
    )
  end

  private

  def initialize recorder:, dispatch:, responder:
    @recorder, @dispatch, @responder = recorder, dispatch, responder
  end
end
