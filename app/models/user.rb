class User < ApplicationRecord
  def self.register_from_contact contact
    u = User.where(telegram_id: contact.user_id).first_or_initialize
    u.update!(
      first_name:   contact.first_name,
      last_name:    contact.last_name,
      phone_number: contact.phone_number
    )
    u
  end

  def name
    [first_name, last_name].join " "
  end
end
