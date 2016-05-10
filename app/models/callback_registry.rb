class CallbackRegistry
  def self.build data
    data.is_a?(CallbackRegistry) ? data : new(data)
  end

  def initialize callbacks
    @callbacks = {}
    callbacks.each { |key, handler| @callbacks[key.to_sym] = handler }
  end

  def [] key
    @callbacks[key.to_sym]
  end

  def buttons data, button_klass: Handlers::Handler::Types::InlineKeyboardButton
    data.map do |key, label|
      raise "Callback not registered: #{key}" unless self[key]
      button_klass.new text: label, callback_data: { key: key }.to_json
    end
  end
end
