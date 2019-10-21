# frozen_string_literal: true

class Payment
  def initialize(charge_details)
    @vrn = charge_details['vrn']
    @dates = charge_details['dates']
    @zone_id = charge_details['la']
    daily_charge = charge_details['daily_charge']
    @total_charge = daily_charge * @dates.length
  end

  def payment_id
    payment_details['paymentId']
  end

  def gov_uk_pay_url
    payment_details['nextUrl']
  end

  private

  attr_reader :vrn, :dates, :zone_id, :total_charge

  def payment_details
    @payment_details ||= PaymentsApi.create_payment(
      vrn: vrn, zone_id: zone_id, amount: total_charge, days: dates
    )
  end
end
