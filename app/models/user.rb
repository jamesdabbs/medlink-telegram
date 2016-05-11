class User < ApplicationRecord
  def self.by_telegram_id id
    User.where(telegram_id: id).first_or_create!
  end

  def attach contact:
    update!(
      first_name:   contact.first_name,
      last_name:    contact.last_name,
      phone_number: contact.phone_number
    )
  end

  def registered?
    phone_number.present?
  end

  def medlinked?
    # TODO: this is currently trusting that the phone number will
    #   be valid and findable in Medlink. This is not true.
    phone_number.present?
  end

  def name
    [first_name, last_name].join " "
  end
end
