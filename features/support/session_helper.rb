# frozen_string_literal: true

module SessionHelper
  def add_vrn_and_country_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'UK' })
  end

  def add_vrn_and_non_uk_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'Non-UK' })
  end

  def add_vrn_country_la_to_session
    page.set_rack_session(vehicle_details: compliance_details)
  end

  def add_vehicle_details_to_session(add_dates: false, add_payment_id: false)
    details = compliance_details
    details.merge!(dates: dates, total_charge: dates.length * 9) if add_dates || add_payment_id
    details[:payment_id] = SecureRandom.uuid if add_payment_id
    page.set_rack_session(vehicle_details: details)
  end

  def add_weekly_vehicle_details_to_session
    details = {
      **compliance_details,
      dates: (Date.current..(Date.current + 6.days)).map(&:to_s),
      total_charge: 50,
      weekly_possible: true,
      weekly: true
    }

    page.set_rack_session(vehicle_details: details)
  end

  private

  def vrn
    'CU57ABC'
  end

  def random_la_uuid
    SecureRandom.uuid
  end

  def dates
    [Date.current, Date.current.tomorrow].map(&:to_s)
  end

  def compliance_details
    { vrn: vrn, country: 'UK', la_id: random_la_uuid, la_name: 'Leeds', daily_charge: 9 }
  end
end

World(SessionHelper)
