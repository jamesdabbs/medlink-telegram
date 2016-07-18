source 'https://rubygems.org'
ruby '2.3.1'


gem 'rails', '~> 5.0.0'
gem 'pg'
gem 'puma'
gem 'sass-rails', '~> 5.0'
gem 'coffee-rails', '~> 4.2'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'rollbar'
gem 'pry-rails'

gem 'jbuilder', '~> 2.0'

gem 'figaro'
gem 'medlink', path: File.expand_path('../../medlink-gem', __FILE__)
gem 'telegram-bot-ruby', require: 'telegram/bot'
gem 'text'

gem 'json', '~> 2.0'

group :development, :test do
  gem 'httparty'
  gem 'rspec-rails'
end

group :development do
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov'
  gem 'coveralls'
  gem 'factory_girl_rails'
end
