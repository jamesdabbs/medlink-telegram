class ResponseRecorder
  def initialize request, error_handler: nil
    # TODO: record the original Update object, not just the message
    # TODO: what if this save fails?
    @receipt  = Message.create! raw: request.message.to_h
    @request  = request
    @response = Bot::Response.new
    @error_handler = error_handler
  end

  def call &block
    block.call response
    receipt.update! handled: response.handled?, response: response.messages
  rescue StandardError => e
    handle_error e
  end

  private

  attr_reader :receipt, :request, :response, :error_handler

  def handle_error e
    receipt.update! error: serialize_error(e)
    if error_handler
      error_handler.new(request, response).run e
    end
  end

  def serialize_error e
    {
      message:  e.to_s,
      location: e.backtrace.reject { |l| l.include?('ruby/gem') }.first(5)
    }
  end
end
