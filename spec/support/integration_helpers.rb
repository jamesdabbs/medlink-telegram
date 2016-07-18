module IntegrationHelpers
  def testbot db:
    recorder = if db
      ResponseRecorder.new(
        persist:       ->(r) { r.save! validate: false },
        error_handler: ->(c, error) { raise error }
      )
    else
      noop
    end
    MedlinkTelegram.bot.with recorder: recorder
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

  def see pattern, buttons: nil
    expect(replies.map &:text).to include match pattern
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
    @chat_id = nil
  end
end
