# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CitizensChargePayment
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    feedback_url_default = 'https://www.example.com'
    config.x.feedback_url = ENV.fetch('FEEDBACK_URL', feedback_url_default)

    config.x.service_name = 'Pay a Clean Air Zone charge'

    check_air_standard_url = 'https://www.example.com'
    config.x.check_air_standard_url = ENV.fetch(
      'COMPLIANCE_CHECKER_UI_URL',
      check_air_standard_url
    )

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    config.time_zone = 'London'
  end
end
