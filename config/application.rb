require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

class Container
  include Dry::Container::Mixin

  # Items should resolve to service objects (with `#call` as their api), but we register
  # procs (so that we can defer builing until the app is loaded).
  # Rather than getting lost in `call`s, we'll use this custom resolver
  configure do |config|
    config.registry = ->(container, key, builder, options) { container[key] = builder }
    config.resolver = ->(container, key) {
      container[:_cache]      ||= Concurrent::Hash.new
      container[:_cache][key] ||= container.fetch(key).call
    }
  end

  def reload key
    purge key
    resolve key
  end

  def purge key
    return unless _container[:_cache]
    _container[:_cache].delete key
  end

  def reset!
    _container[:_cache].clear
  end
end

module MedlinkTelegram
  class Application < Rails::Application
    config.container = Container.new.tap do |c|
      c.register :bot,     -> { Medbot }
      c.register :mailbox, -> { Mailbox.new }
    end
  end

  %i( bot mailbox ).each do |key|
    define_singleton_method key do
      Rails.application.config.container.resolve key
    end
  end
end
