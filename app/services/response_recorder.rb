class ResponseRecorder
  def initialize persist:, error_handler:
    @persist, @error_handler = persist, error_handler
  end

  def call request, responder, &block
    receipt = Receipt.new request: request.message.to_h
    persist.call receipt

    response = Bot::Response.new responder: responder
    block.call response
  rescue StandardError => e
    receipt.error = serialize_error(e)
    error_handler.call request, response, e
  ensure
    receipt.assign_attributes \
      response: response.messages, handled: response.handled?
    persist.call receipt
  end

  private

  attr_reader :persist, :error_handler

  def serialize_error e
    {
      message:  e.to_s,
      location: e.backtrace.reject { |l| l.include?('ruby/gem') }.first(5)
    }
  end
end
