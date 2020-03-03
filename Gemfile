# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 6.0.2.1'

gem 'bootsnap', require: false
gem 'brakeman'
gem 'bundler-audit'
gem 'haml'
gem 'httparty'
gem 'logstash-logger'
gem 'puma'
gem 'rubocop-rails'
gem 'scss_lint-govuk', require: false
gem 'sdoc', require: false
gem 'sqlite3'
gem 'turbolinks'
gem 'webpacker'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'haml-rails'
  gem 'rspec-rails', '~> 4.0.0.beta'
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
  gem 'capybara'
  gem 'cucumber-rails', require: false
  # Used to set session values in cucumber tests
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'simplecov', '~> 0.17.1', require: false
  gem 'webdrivers'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
