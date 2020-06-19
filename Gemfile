# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'rails', '~> 6.0.3.2'

gem 'bootsnap', require: false
gem 'haml'
gem 'httparty'
gem 'puma'
gem 'sdoc', require: false
gem 'sqlite3'
gem 'turbolinks'
gem 'webpacker'

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'haml-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rubocop-rails'
  gem 'scss_lint-govuk', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'webdrivers'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
