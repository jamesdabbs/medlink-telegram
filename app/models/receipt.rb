class Receipt < ApplicationRecord
  belongs_to :user

  serialize :request,  JSON
  serialize :error,    JSON
  serialize :response, JSON

  def request
    @_request ||= Telegram::Bot::Types::Message.new(self[:request])
  end

  Error = Struct.new :message, :location
  def error
    json = self[:error]
    return unless json
    Error.new json["message"], json["location"]
  end

  def response
    json = self[:response]
    return unless json
    json.map do |h|
      Bot::Response::Item.new h["text"], markup: h["markup"]
    end
  end
end
