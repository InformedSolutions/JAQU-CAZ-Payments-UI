# frozen_string_literal: true

# Methods used to manipulate the session data in rspec tests
module SessionHelper
  def add_to_session(data = {})
    page.set_rack_session(data)
  end

  def add_vrn_and_country_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'UK' })
  end

  def add_vrn_and_non_uk_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'Non-UK' })
  end

  def add_unrecognised_uk_vehicle_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'UK', unrecognised: true })
  end

  def add_vrn_country_la_to_session
    page.set_rack_session(vehicle_details: compliance_details)
  end

  def add_vehicle_details_to_session(add_dates: false, add_payment_id: false, chargeable_zones: 2)
    details = compliance_details
    details.merge!(dates: dates, total_charge: dates.length * 9) if add_dates || add_payment_id
    details[:payment_id] = SecureRandom.uuid if add_payment_id
    details[:chargeable_zones] = chargeable_zones
    page.set_rack_session(vehicle_details: details)
  end

  def add_weekly_possible_details
    details = { **compliance_details, weekly_possible: true }
    page.set_rack_session(vehicle_details: details)
  end

  def add_weekly_vehicle_details_to_session(weekly_charge_today: false, weekly_dates: [])
    details = {
      **compliance_details,
      **weekly_charge_details(weekly_charge_today, weekly_dates)
    }

    page.set_rack_session(vehicle_details: details)
  end

  private

  def vrn
    'CU57ABC'
  end

  def la_uuid
    '7d0c4240-1618-446b-bde2-2f3458c8a520'
  end

  def dates
    [Date.current, Date.current.tomorrow].map(&:to_s)
  end

  def compliance_details
    { vrn: vrn, country: 'UK', la_id: la_uuid, la_name: 'Taxidiscountcaz', daily_charge: 9 }
  end

  def weekly_charge_details(weekly_charge_today, weekly_dates)
    {
      dates: (Date.current..(Date.current + 6.days)).map(&:to_s),
      total_charge: 50,
      weekly_possible: true,
      weekly_charge_today: weekly_charge_today,
      weekly_dates: weekly_dates,
      weekly: true,
      chargeable_zones: 2
    }
  end
end

World(SessionHelper)
