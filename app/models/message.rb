class Message < ApplicationRecord
  # N.B. We expect to get a few messages from a user before we can start
  #      recording this.
  belongs_to :user, required: false

  serialize :raw, JSON
  serialize :error, JSON
  serialize :response, JSON

  def message
    @_message ||= Telegram::Bot::Types::Message.new(raw)
  end
end
