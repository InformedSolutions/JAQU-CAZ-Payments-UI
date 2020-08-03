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
  #   * +total_charge+ - total charge value for selected vehicle in selected CAZ in pounds, eg. 50
  #   * +la_id+ = ID of the selected CAZ
  #   * +dates+ = array of the selected days in the right format, eg. ['2019-05-14', '2019-05-15']
  #   * +tariff_code+ - code of the payment tariff, eg. 'BCC01-private_car'
  #
  def initialize(charge_details, return_url)
    @charge_details = charge_details
    @return_url = return_url
  end

  # Returns internal ID of the payment
  def payment_id
    payment_details['paymentId']
  end

  # Returns central reference denoting payment
  def payment_reference
    payment_details['centralReference']
  end

  # Returns ID assigned to the payment by GovUK.Pay
  def external_id
    payment_details['paymentProviderId']
  end

  # Return URL for continuing of the payment process
  def gov_uk_pay_url
    payment_details['nextUrl']
  end

  private

  # Reader functions for variables
  attr_reader :charge_details, :return_url

  # Calls PaymentsApi.create_payment with right data
  def payment_details
    @payment_details ||= PaymentsApi.create_payment(
      zone_id: charge_details['la_id'],
      transactions: charge_details['weekly'] ? weekly_transactions : daily_transactions,
      return_url: return_url
    )
  end

  # Creates transactions array for a daily flow
  def daily_transactions
    charge_details['dates'].map do |day|
      transaction(day, charge_details['daily_charge'])
    end
  end

  # Creates transactions array for a weekly flow with fixed charges
  def weekly_transactions
    transactions = charge_details['dates'].map do |day|
      transaction(day, 7.14)
    end
    # Set value for the sum to equal 50
    transactions.last[:charge] = charge_in_pence(7.16)
    transactions
  end

  # Create single transaction object
  def transaction(day, charge)
    {
      vrn: charge_details['vrn'],
      travelDate: day,
      tariffCode: charge_details['tariff_code'],
      charge: charge_in_pence(charge)
    }
  end

  # convert charge in pence
  def charge_in_pence(charge_in_pounds)
    (charge_in_pounds.to_f * 100).to_i
  end
end
