Channel.where(name: :support).first_or_create! do |c|
  c.chat_id = Figaro.env.telegram_support_chat_id!
end
