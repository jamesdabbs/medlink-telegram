module Factories
  def build klass, **opts
    builder = {
      User     => :build_user,
      Supply   => :build_supply,
      Order    => :build_order,
      :message => :build_message,
      :contact => :build_contact
    }[klass]

    if builder
      send builder, **opts
    else
      raise "Factory not registered: #{klass}"
    end
  end

  def build_supply name: nil, shortcode: nil
    instance_double Supply,
      id:        rand(1 .. 1000),
      name:      name      || rand.to_s,
      shortcode: shortcode || rand.to_s
  end

  def build_user name: nil, ordering: false
    instance_double User,
      first_name: name || rand.to_s,
      name:       name || rand.to_s,
      ordering?:  ordering
  end

  def build_message text:, contact: nil
    chat = double "Chat", id: rand(1 .. 1000)
    instance_double Telegram::Bot::Types::Message,
      text: text, contact: contact, chat: chat
  end

  def build_order supply: nil
    supply ||= build_supply
    instance_double Order, supply: supply, placed_at: rand(1..14).days.ago
  end

  def build_contact user_id: nil
    user_id ||= rand(1 .. 1000)
    instance_double Telegram::Bot::Types::Contact,
      user_id:      user_id,
      first_name:   "First",
      last_name:    "Last",
      phone_number: "555-5555"
  end
end
