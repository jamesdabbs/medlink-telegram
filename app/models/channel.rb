class Channel < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :chat_id, presence: true, uniqueness: true

  def self.by_name name
    find_by! name: name
  end
end
