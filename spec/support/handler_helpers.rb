# TODO: there's a lot of overlap between this and the integration helpers
module HandlerHelpers
  def subject
    described_class
  end

  def context
    @context ||= Handlers::Context.new(
      build(:message, text: ""), response, Medbot.dispatch, medlink: medlink)
  end

  def user= u
    allow(context).to receive(:user).and_return(u)
  end
  def message= m
    allow(context).to receive(:message).and_return(m)
  end

  def response
    @response ||= Bot::Response.new responder: ->(*_) { }
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
    @found = Medbot.dispatch.find(context).class
    klass == @found
  end

  failure_message do |klass|
    "Expected `#{text}` to route to #{klass}, not #{@found}"
  end
end
