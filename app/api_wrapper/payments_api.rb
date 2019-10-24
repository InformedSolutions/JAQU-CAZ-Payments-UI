# frozen_string_literal: true

##
# This class wraps calls being made to the Payments backend API.
# The base URL for the calls is configured by +PAYMENTS_API_URL+ environment variable.
#
# All calls will automatically have the correlation ID and JSON content type added to the header.
#
# All methods are on the class level, so there is no initializer method.
#
class PaymentsApi < BaseApi
  base_uri ENV.fetch('PAYMENTS_API_URL', '') + '/v1'

  headers(
    'Content-Type' => 'application/json',
    'X-Correlation-ID' => -> { SecureRandom.uuid }
  )

  class << self
    # Calls +/v1/payments+ endpoint with +POST+ method which triggers the payment creation
    # and returns details of the requested vehicle.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number
    # * +amount+ - Total charge value, eg. 50
    # * +zone_id+ - ID of the selected CAZ
    # * +days+ - array of the selected days in the right format, eg. ['2019-05-14', '2019-05-15']
    # * +return_url+ - URL where GOC.UK Pay should redirect after the payment is done
    #
    # ==== Example
    #
    #    PaymentsApi.create_payment(
    #      vrn: 'CU57ABC',
    #      amount: 50,
    #      zone_id: '86b64512-154c-4033-a64d-92e8ed19275f',
    #      days: ['2019-05-14', '2019-05-15'],
    #      return_url: 'http://example.com'
    #    )
    #
    # ==== Result
    #
    # Returned payment details will have the following fields:
    # * +paymentId+ - uuid, ID of the payment created in GovUK.Pay
    # * +nextUrl+ - URL, url returned by GovUK.Pay to proceed the payment
    #
    # ==== Serialization
    #
    # {Payment model}[rdoc-ref:Payment]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {422 Exception}[rdoc-ref:BaseApi::Error422Exception] - invalid data
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def create_payment(vrn:, amount:, zone_id:, days:, return_url:)
      log_action(
        "Getting a payment, vrn: #{vrn}, amount: #{amount}, zone id: #{zone_id}, days: #{days.join(',')}"
      )
      request(:post, '/payments', body: {
        days: days, vrn: vrn, amount: amount,
        'cleanAirZoneId' => zone_id, 'returnUrl' => return_url
      }.to_json)
    end
  end
end
