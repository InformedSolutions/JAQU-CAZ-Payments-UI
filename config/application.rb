# frozen_string_literal: true

require_relative 'boot'
require_relative 'log_format'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CitizensChargePayment
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    default_url = 'https://www.example.com'
    config.x.feedback_url = ENV.fetch('FEEDBACK_URL', default_url)

    config.x.service_name = 'Pay a Clean Air Zone charge'

    config.x.check_air_standard_url = ENV.fetch('COMPLIANCE_CHECKER_UI_URL', default_url)
    fleets_ui_url = ENV.fetch('FLEETS_UI_URL', default_url)
    config.x.fleets_ui_url = fleets_ui_url
    config.x.fleets_ui_accounts_url = "#{fleets_ui_url}/organisations"

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    config.time_zone = 'London'

    # Use custom logging formatter so that IP addresses are removed.
    config.logger = LogStashLogger.new(type: :stdout, formatter: Formatter)

    # Use the lowest log level to ensure availability of diagnostic information
    # when problems arise.
    config.log_level = :debug
  end
end
