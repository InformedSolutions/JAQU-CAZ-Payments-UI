# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JaquCaz
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # http://www.glitchwrks.com/2017/01/16/removing-cookies-sessions-rails-5
    config.middleware.delete ActionDispatch::Cookies
    config.middleware.delete ActionDispatch::Session::CookieStore

    feedback_url_default = nil
    config.x.feedback_url = (ENV['FEEDBACK_URL'].presence || feedback_url_default)

    config.x.service_name = 'Pay a Clean Air Zone charge'
  end
end
