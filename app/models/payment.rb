# frozen_string_literal: true

##
# This class represents data returned by create payment API endpoint
#
class Payment
  ##
  # Creates an instance of a form class, make keys underscore and transform to symbols.
  #
  # ==== Attributes
  #
  # * +charge_details+ - hash
  #   * +vrn+ - Vehicle registration number
  #   * +daily_charge+ - Daily charge value for selected vehicle in selected CAZ, eg. 50
  #   * +la+ = ID of the selected CAZ
  #   * +dates+ = array of the selected days in the right format, eg. ['2019-05-14', '2019-05-15']
  #
  def initialize(charge_details, return_url, total_charge)
    @vrn = charge_details['vrn']
    @dates = charge_details['dates']
    @zone_id = charge_details['la']
    @total_charge = total_charge
    @return_url = return_url
  end

  # Returns ID assigned to the payment by GovUK.Pay
  def payment_id
    payment_details['paymentId']
  end

  # Return URL for continuing of the payment process
  def gov_uk_pay_url
    payment_details['nextUrl']
  end

  private

  # Reader functions for variables
  attr_reader :vrn, :dates, :zone_id, :total_charge, :return_url

  # Calls PaymentsApi.create_payment with right data
  def payment_details
    @payment_details ||= PaymentsApi.create_payment(
      vrn: vrn, zone_id: zone_id, amount: total_charge, days: dates, return_url: return_url
    )
  end
end
