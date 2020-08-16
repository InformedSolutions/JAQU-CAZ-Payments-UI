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

    # Load lib folder files
    config.eager_load_paths << Rails.root.join('lib')

    default_url = 'https://www.example.com'
    config.x.feedback_url = ENV.fetch('FEEDBACK_URL', 'https://defragroup.eu.qualtrics.com/jfe/form/SV_3ymAC1qqYAEVJgF')

    config.x.service_name = 'Drive in a Clean Air Zone'

    config.x.check_air_standard_url = ENV.fetch('COMPLIANCE_CHECKER_UI_URL', default_url)
    fleets_ui_url = ENV.fetch('FLEETS_UI_URL', default_url)
    config.x.fleets_ui_url = fleets_ui_url
    config.x.fleets_ui_accounts_url = "#{fleets_ui_url}/organisations"

    # https://mattbrictson.com/dynamic-rails-error-pages
    config.exceptions_app = routes

    config.time_zone = 'London'
  end
end
