# frozen_string_literal: true

module SessionHelper
  def add_vrn_to_session
    page.set_rack_session(vehicle_details: { vrn: vrn, country: 'UK' })
  end

  def add_la_to_session
    page.set_rack_session(la: SecureRandom.uuid)
  end

  def add_dates_to_session
    page.set_rack_session(dates: [Date.current, Date.current.tomorrow])
  end

  def add_daily_charge_to_session
    page.set_rack_session(daily_charge: 9.0)
  end

  def vrn
    'CU57ABC'
  end
end

World(SessionHelper)
