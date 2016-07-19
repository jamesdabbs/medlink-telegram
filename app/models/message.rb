require "medlink/struct"

class Message < Medlink.struct(:chat_id, :contact, :sender_id, :text)
  def self.from_update u
    new \
      chat_id:   u.message.chat.try(:id),
      contact:   u.message.contact,
      sender_id: u.message.from.try(:id),
      text:      u.message.text
  end

  def as_json
    to_h.merge type: "message"
  end
end
