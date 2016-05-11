# TODO: there's a lot of overlap between this and the integration helpers
module HandlerHelpers
  def subject
    described_class
  end

  def context
    @context ||= Handlers::Context.new(
      request, response, Medbot.dispatch, medlink: medlink)
  end

  def request
    @request ||= instance_double Bot::Request, user: nil, medlink: medlink
  end
  def user= u
    allow(request).to receive(:user).and_return(u)
  end
  def message= m
    allow(request).to receive(:message).and_return(m)
  end

  def response
    @response ||= Bot::Response.new responder: ->(*_) { }
  end

  def medlink
    @medlink ||= instance_double Medlink
  end

  def pcv
    @pcv ||= build User, name: "PCV"
  end

  def run user: nil, message: nil, text: "", with: nil
    self.user    = user if user
    self.message = message || build(:message, text: text)
    with ? context.call(described_class, **with) : context.call(described_class)
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
    self.message = build :message, text: text
    handler = Medbot.dispatch.find(request)
    klass == handler.class
  end
end

RSpec::Matchers.define :use_handler do |klass|
  match do |response|
    response.handlers.any? { |h| h.is_a? klass }
  end
end
