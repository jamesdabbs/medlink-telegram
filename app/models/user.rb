class User < ApplicationRecord
  validates_presence_of :telegram_id

  has_many :receipts

  def self.support
    by_telegram_id 999 # TODO
  end

  def self.by_telegram_id id
    User.where(telegram_id: id).first_or_create!
  end

  def attach contact:, credentials:
    update! \
      first_name:    contact.first_name,
      last_name:     contact.last_name,
      phone_number:  contact.phone_number,
      medlink_id:    credentials.try(:user_id),
      medlink_token: credentials.try(:token)
  end

  def credentials
    Medlink::Client::Credentials.new user_id: medlink_id, token: medlink_token
  end

  def registered?
    phone_number.present?
  end

  def medlinked?
    medlink_id.present?
  end

  def name
    [first_name, last_name].join " "
  end

  def needs_help!
    update! needs_help: true
  end
  def has_been_helped!
    update! needs_help: false
  end
end
