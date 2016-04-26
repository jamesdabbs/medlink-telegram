module HandlerHelpers
  def subject
    described_class
  end

  def request
    @request ||= Bot::Request::Test.new
  end

  def response
    @response ||= Bot::Response.new
  end

  def medlink
    @medlink ||= instance_double Medlink
  end

  def pcv
    @pcv ||= build User, name: "PCV"
  end

  def run user: nil, message: nil, text: nil, with: {}
    raise "Need `message` or `text`" unless message || text
    message ||= double "Message", text: text

    request.user    = user if user
    request.message = message || double("message", text: text)

    handler = described_class.new request, response, medlink: medlink
    with.any? ? handler.run(**with) : handler.run

    raise response.error if response.error
    response
  end

  def route text
    request.message = double "Message", text: text, contact: nil
    handler = Handlers.find request, handlers: Bot.default_handlers

    _route_to text, handler
  end

  def messages
    response.messages
  end

  def replies
    messages.map &:text
  end
end
