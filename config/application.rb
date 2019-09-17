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

module CitizensChargePayment
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    feedback_url_default = 'https://www.example.com'
    config.x.feedback_url = (ENV['FEEDBACK_URL'].presence || feedback_url_default)

    config.x.service_name = 'Pay a Clean Air Zone charge'

    check_air_standard_url = 'https://www.example.com'
    config.x.check_air_standard_url = (
      ENV['CHECK_AIR_STANDARD_URL'].presence || check_air_standard_url
    )
  end
end
