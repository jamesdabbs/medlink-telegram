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

  def run user: nil, message: nil, text: "", with: {}
    request.user    = user if user
    request.message = message || build(:message, text: text)

    handler = described_class.new request, response, medlink: medlink
    with.any? ? handler.run(**with) : handler.run

    response
  end

  def messages
    response.messages
  end

  def replies
    messages.map &:text
  end
end

RSpec::Matchers.define :route do |text|
  match do |klass|
    request.message = build :message, text: text
    handler = Handlers.find request, Bot::Response.new, handlers: Medbot.handlers
    klass == handler.class
  end
end

RSpec::Matchers.define :use_handler do |klass|
  match do |response|
    response.handlers.any? { |h| h.is_a? klass }
  end
end
