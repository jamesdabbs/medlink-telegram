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
    bot.call build :message, text: text, chat_id: @chat_id
  end

  def send_contact_info
    bot.call build :message, text: "", chat_id: @chat_id, contact: build_contact(user_id: @chat_id)
  end

  def send_callback data
    opts = JSON.parse(data).transform_keys &:to_sym
    key  = opts.delete :key
    bot.callback key, sender_id: @chat_id, **opts
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
    if block_given?
      yield
      @chat_id = nil
    end
  end

  def as_support
    @chat_id = Channel.by_name(:support).chat_id
    if block_given?
      yield
      @chat_id = nil
    end
  end
end
