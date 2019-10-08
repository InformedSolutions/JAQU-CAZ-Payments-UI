# frozen_string_literal: true

module AddVrnToSession
  def add_vrn_to_session(vrn: 'CU57ABC', country: 'UK')
    post submit_details_vehicles_path, params: { vrn: vrn, 'registration-country': country }
  end

  def add_la_to_session(zone_id = SecureRandom.uuid)
    post submit_local_authority_charges_path, params: { 'local-authority' => zone_id }
  end
end
