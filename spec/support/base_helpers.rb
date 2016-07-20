module BaseHelpers
  def noop
    ->(*_, &block) { block.call if block }
  end

  def replies chat_id=nil
    MedlinkTelegram.mailbox.held(chat_id || @chat_id)
  end
end

RSpec.configure do |config|
  config.before :each do
    @chat_id = rand 1 .. 1_000_000
    MedlinkTelegram.mailbox.clear
  end
end
