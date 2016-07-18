module IntegrationHelpers
  def test_recorder
    ResponseRecorder.new(
      persist:       ->(r) { receipts.push(r) unless receipts.include?(r) },
      error_handler: ->(c) { raise c.error }
    )
  end

  def receipts
    @_receipts ||= []
  end

  def test_responder
    ->(request, message) { replies.push message }
  end

  def replies
    @_replies ||= []
  end

  def testbot
    Medbot.with(
      recorder:  test_recorder,
      responder: test_responder
    )
  end

  def failbot
    Medbot.with(
      responder: test_responder,
      dispatch:  ->(c) { raise "Bot failure" }
    )
  end

  def say text
    send_message build :message, text: text, chat_id: @chat_id
  end

  def send_contact_info
    send_message build :message, text: "", chat_id: @chat_id, contact: {
      user_id:      @chat_id,
      first_name:   "James",
      last_name:    "Dabbs",
      phone_number: "+1 555 867-5309"
    }
  end

  def send_callback data
    send_message build :callback, chat_id: @chat_id, data: data
  end

  def send_message message
    bot.call message, medlink: medlink
  end

  def see match, buttons: nil
    message = replies.find { |m| m.text =~ match }
    expect(message).to be_present
    if buttons
      expect(replies.last.buttons.count).to eq buttons
    end
  end

  def click matcher
    replies.reverse.each do |r|
      next unless r.markup.try :inline_keyboard
      r.markup.inline_keyboard.flatten.each do |b|
        if b.text =~ matcher
          unless b.callback_data.present?
            raise "Matching button has no callback data"
          end
          return send_callback(b.callback_data)
        end
      end
    end
    raise "No button matched #{matcher}"
  end

  def as user
    @chat_id = user.telegram_id
    yield
  end
end

RSpec.configure do |config|
  config.before :each, integration: true do
    @chat_id = rand 1 .. 1_000_000
    receipts.clear
    replies.clear
  end
end
