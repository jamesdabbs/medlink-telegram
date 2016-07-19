require "medlink/struct"

class Callback < Medlink.struct(:sender_id, :key, :data)
  def self.from_update u
    data = u.callback_query.data.transform_keys &:to_sym
    new \
      sender_id: u.callback_query.from.try(:id),
      key:       data.delete(:key),
      data:      data
  end

  def chat_id
    sender_id
  end

  def as_json
    to_h.merge type: "callback"
  end
end
