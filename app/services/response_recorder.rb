require "medlink/struct"

class ResponseRecorder < Medlink.struct(:persist, :error_handler)
  def call c, &block
    receipt = Receipt.new request: c.message.as_json, user: c.sender
    persist.call receipt

    begin
      block.call
    rescue StandardError => e
      receipt.error = serialize_error(e)
      error_handler.call c, e
    ensure
      receipt.assign_attributes \
        response: c.response.messages, handled: c.handled?
      persist.call receipt
    end
  end

  private

  def serialize_error e
    {
      message:  e.to_s,
      location: e.backtrace.reject { |l| l.include?('ruby/gem') }.first(5)
    }
  end
end
