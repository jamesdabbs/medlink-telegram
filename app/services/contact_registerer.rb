class ContactRegisterer < Medlink.struct(:medlink, :telegram)
  def self.for bot:
    new medlink: bot.medlink, telegram: bot.telegram
  end

  def call user:, contact:
    username    = telegram.get_username chat_id: contact.user_id
    credentials = medlink.credentials_for_phone_number contact.phone_number
    user.attach contact: contact, credentials: credentials, telegram_username: username
  end
end
