source 'https://rubygems.org'
ruby '2.2.4'


gem 'rails', '>= 5.0.0.beta3', '< 5.1'
gem 'pg'
gem 'puma'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks', '~> 5.x'
gem 'rollbar'

gem 'jbuilder', '~> 2.0'

gem 'figaro'
gem 'telegram-bot-ruby', require: 'telegram/bot'

gem 'rest-client'
gem 'api-auth'

gem 'text'

group :development, :test do
  gem 'httparty'
  gem 'byebug'
  gem 'pry-rails'

  # Pulling these from master fixes a few Rails 5 compatibility issues
  gem 'rspec', github: 'rspec/rspec'
  %w( core expectations mocks support rails ).each do |m|
    gem "rspec-#{m}", github: "rspec/rspec-#{m}"
  end
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov'
  gem 'coveralls'
end
