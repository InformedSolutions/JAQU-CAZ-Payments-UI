# frozen_string_literal: true

module SessionHelper
  def add_vrn_and_country_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'UK' })
  end

  def add_vrn_and_non_uk_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'Non-UK' })
  end

  def add_vrn_country_la_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'UK', la_id: random_la_uuid })
  end

  def add_vehicle_details_to_session(add_payment_id: false)
    details = {
      vrn: vrn,
      country: 'UK',
      la_id: random_la_uuid,
      la_name: 'Leeds',
      dates: dates,
      charge: 9.0
    }
    details[:payment_id] = SecureRandom.uuid if add_payment_id
    page.set_rack_session(vehicle_details: details)
  end

  def add_weekly_vehicle_details_to_session
    details = {
      vrn: vrn,
      country: 'UK',
      la_id: random_la_uuid,
      la_name: 'Leeds',
      dates: [Date.current],
      charge: 50,
      weekly_period: true
    }

    page.set_rack_session(vehicle_details: details)
  end

  def add_unrecognised_vrn_to_session
    page.set_rack_session(vehicle_details: { vrn: 'CU27ABA', country: 'UK' })
  end

  private

  def vrn
    'CU57ABC'
  end

  def random_la_uuid
    SecureRandom.uuid
  end

  def dates
    [Date.current, Date.current.tomorrow]
  end
end

World(SessionHelper)
