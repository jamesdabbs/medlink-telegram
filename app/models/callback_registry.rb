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

  def fetch key
    self[key] || raise("Callback not registered: #{key}")
  end

  def buttons data, button_klass: nil
    data.map do |key, label|
      button key, label, button_klass: button_klass
    end
  end

  def button key, label, **data
    button_klass = data.delete(:button_klass) || \
      Handlers::Handler::Types::InlineKeyboardButton
    raise "Callback not registered: #{key}" unless self[key]
    button_klass.new text: label, callback_data: data.merge(key: key).to_json
  end

  def inspect
    # :nocov:
    %|<#{self.class.name}[#{@callbacks.keys.map(&:to_s).join(", ")}]>|
    # :nocov:
  end
end
