class Bot
  def call message, **opts
    response = Bot::Response.new responder: responder
    context  = Handlers::Context.new message, response, dispatch, **opts

    recorder.call context do
      dispatch.call context
    end
  end

  def receive update:
    message = update.message || update.callback.query
    call message
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
    freeze
  end
end
