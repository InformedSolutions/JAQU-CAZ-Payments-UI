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
  base_uri "#{ENV.fetch('PAYMENTS_API_URL', 'localhost:3001')}/v1"

  class << self
    # Calls +/v1/payments+ endpoint with +POST+ method which triggers the payment creation
    # and returns details of the requested vehicle.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number
    # * +zone_id+ - ID of the selected CAZ
    # * +return_url+ - URL where GOC.UK Pay should redirect after the payment is done
    # * +transaction+ - array of objects
    #   * +vrn+ - Vehicle registration number
    #   * +travelDate+ - Date of the single transaction
    #   * +tariffCode+ - tariff code used for calculations
    #   * +charge+ - transaction charge value (daily charge)
    #
    # ==== Example
    #
    #    PaymentsApi.create_payment(
    #      zone_id: '86b64512-154c-4033-a64d-92e8ed19275f',
    #      transactions: [
    #         {
    #            vrn: 'CU57ABC',
    #            travelDate: '2019-05-14',
    #            tariffCode: 'BCC01-private_car',
    #            charge: 7.16
    #         }
    #      ],
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
    def create_payment(zone_id:, transactions:, return_url:)
      log_action('Creating payment')
      body = payment_creation_body(transactions, zone_id, return_url)
      request(:post, '/payments', body: body.to_json)
    end

    # Calls +/v1/payments/:id+ endpoint with +PUT+ method which returns details of the payment.
    #
    # ==== Attributes
    #
    # * +payment_id+ - Payment ID returned by backend API during the payment creation
    #
    # ==== Example
    #
    #    PaymentsApi.payment_status(payment_id: '86b64512-154c-4033-a64d-92e8ed19275f')
    #
    # ==== Result
    #
    # Returned payment details will have the following fields:
    # * +referenceNumber+ - integer, central reference number of the payment
    # * +externalPaymentId+ - string, external identifier for the payment
    # * +status+ - string, status of the payment eg. "success"
    # * +userEmail+ - email, email submitted by the user during the payment process
    #
    # ==== Serialization
    #
    # {PaymentStatus model}[rdoc-ref:PaymentStatus]
    # can be used to create an instance referring to the returned data
    #
    # ==== Exceptions
    #
    # * {404 Exception}[rdoc-ref:BaseApi::Error404Exception] - payment not found
    # * {500 Exception}[rdoc-ref:BaseApi::Error500Exception] - backend API error
    #
    def payment_status(payment_id:)
      log_action("Getting a payment status for id: #{payment_id}")
      request(:put, "/payments/#{payment_id}")
    end

    ##
    # Calls +/v1/payments/paid+ endpoint with +POST+ method,
    # which returns information about already paid payment in a given time-frame.
    #
    # ==== Attributes
    #
    # * +vrn+ - Vehicle registration number
    # * +zone_id+ - ID of the selected CAZ
    # * +start_date+ - start date of the search time-frame in the right format, eg "2019-10-21"
    # * +end_date+ - end date of the search time-frame in the right format, eg "2019-10-21"
    #
    # ==== Results
    #
    # Returns an array of dates, eg. ["2019-10-21", "2019-10-22"].
    # Empty array means there was no paid payment in the given time-frame.
    #
    def paid_payments_dates(vrn:, zone_id:, start_date:, end_date:)
      log_action('Getting paid payments')
      request(:post, '/payments/paid', body: {
        vrns: [vrn],
        cleanAirZoneId: zone_id,
        startDate: start_date,
        endDate: end_date
      }.to_json)['results'].first['paidDates']
    end

    private

    # Returns parsed to JSON hash of the payment creation parameters with proper keys
    def payment_creation_body(transactions, zone_id, return_url)
      {
        cleanAirZoneId: zone_id,
        returnUrl: return_url,
        transactions: transactions,
        telephonePayment: false
      }
    end
  end
end
