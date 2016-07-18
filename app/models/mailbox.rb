module Mailbox
  extend self

  def hold opts
    chat_id = opts[:chat_id]
    message = opts[:message]

    held(chat_id).push message
  end

  def held chat_id
    all[chat_id] ||= []
  end

  def all
    @held ||= {}
  end

  def clear
    all.clear
  end
end
