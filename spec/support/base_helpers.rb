module BaseHelpers
  def noop
    ->(*_, &block) { block.call if block }
  end

  def medlink
    @medlink ||= instance_double Medlink::User::Client
  end

  def replies chat_id=nil
    Mailbox.held(chat_id || @chat_id)
  end
end

RSpec.configure do |config|
  config.before :each do
    @chat_id = rand 1 .. 1_000_000
    Mailbox.clear
  end
end
