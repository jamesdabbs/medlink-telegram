class Mailbox
  attr_reader :all

  def initialize
    @all = {}
  end

  def hold chat_id:, message:
    held(chat_id).push message
  end

  def held chat_id
    all[chat_id] ||= []
  end

  def clear
    all.clear
  end
end
