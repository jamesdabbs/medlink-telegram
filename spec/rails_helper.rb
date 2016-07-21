ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  config.include BaseHelpers
  config.include HandlerHelpers,     handler: true
  config.include IntegrationHelpers, integration: true
  config.include Factories

  config.before :all do
    Channel.where(name: :support).first_or_create! do |c|
      c.chat_id = rand 20_000 .. 30_000
    end
  end
end
