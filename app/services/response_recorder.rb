class ResponseRecorder
  def initialize persist:, error_handler:
    @persist, @error_handler = persist, error_handler
  end

  def call c, &block
    receipt = Receipt.new request: c.request.message.to_h
    persist.call receipt

    block.call
  rescue StandardError => e
    receipt.error = serialize_error(e)
    c.error = e
    error_handler.call c
  ensure
    receipt.assign_attributes \
      response: c.response.messages, handled: c.handled?
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
