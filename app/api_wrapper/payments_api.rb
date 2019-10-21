# frozen_string_literal: true

##
# This class wraps calls being made to the VCCS backend API.
# The base URL for the calls is configured by +COMPLIANCE_CHECKER_API_URL+ environment variable.
#
# All calls will automatically have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.

class PaymentsApi < BaseApi
  base_uri ENV.fetch('PAYMENTS_API_URL') + '/v1'

  headers(
    'Content-Type' => 'application/json',
    'X-Correlation-ID' => -> { SecureRandom.uuid }
  )

  class << self
    def create_payment(vrn:, amount:, zone_id:, days:)
      log_action "Getting a payment, vrn: #{vrn}, amount: #{amount}, zone id: #{zone_id}"
      request(:post, '/payments', body: {
        days: days, vrn: vrn, amount: amount, 'cleanAirZoneId' => zone_id,
        'returnUrl' => Rails.application.routes.url_helpers.payments_url
      }.to_json)
    end
  end
end
