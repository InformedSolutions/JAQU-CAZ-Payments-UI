# frozen_string_literal: true

module AddVrnToSession
  def add_vrn_to_session(vrn: 'CU57ABC', country: 'UK')
    post enter_details_vehicles_path, params: { vrn: vrn, 'registration-country': country }
  end

  def add_la_to_session(zone_id: SecureRandom.uuid)
    post submit_local_authority_charges_path, params: { 'local-authority': zone_id }
  end

  def add_dates_to_session(dates: [Date.current])
    post confirm_daily_date_charges_path, params: { dates: dates }
  end

  def add_daily_charge_to_session(charge: 10)
    allow(ComplianceDetails).to receive(:new).and_return(
      OpenStruct.new(charge: charge, zone_name: 'Zone')
    )
    get daily_charge_charges_path
  end

  def add_payment_id_to_session
    post payments_path
  end

  def add_to_session(data = {})
    encoded_data = RackSessionAccess.encode(vehicle_details: data)
    put RackSessionAccess.path, params: { data: encoded_data }
  end
end
