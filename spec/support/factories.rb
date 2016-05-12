module Factories
  def build klass, **opts
    builder = {
      User      => :build_user,
      Supply    => :build_supply,
      Order     => :build_order,
      :message  => :build_message,
      :contact  => :build_contact,
      :callback => :build_callback
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

  def pcv
    @pcv ||= build User, name: "PCV", phone_number: "1234", telegram_id: rand(1 .. 1000)
  end

  def build_user name: nil, ordering: false, phone_number: nil, telegram_id: nil
    User.new \
      first_name:   name || rand.to_s,
      last_name:    name || rand.to_s,
      ordering:     ordering,
      phone_number: phone_number,
      telegram_id:  telegram_id || rand(1 .. 10_000)
  end

  def build_message text:, contact: nil, chat_id: nil
    chat_id ||= rand(1 .. 1_000_000)
    Telegram::Bot::Types::Message.new(
      chat:    { id: chat_id },
      text:    text,
      contact: contact,
      from:    { id: chat_id }
    )
  end

  def build_callback data:, **opts
    opts[:text] ||= ""
    message = build_message **opts
    Telegram::Bot::Types::CallbackQuery.new(
      data:    data,
      message: message,
      from:    message.from
    )
  end

  def build_order supply: nil
    supply ||= build_supply
    instance_double Order, supply: supply, placed_at: rand(1..14).days.ago
  end

  def build_contact user_id: nil
    user_id ||= rand(1 .. 1000)
    Telegram::Bot::Types::Contact.new(
      user_id:      user_id,
      first_name:   "First",
      last_name:    "Last",
      phone_number: "555-5555"
    )
  end
end
