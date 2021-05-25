# frozen_string_literal: true

##
# Module used to stub API calls
#
module ApiMocks
  # Mocks data from the vehicle details endpoint in VCCS API
  def mock_vehicle_details
    vehicle_details = read_file('vehicle_details_response.json')
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
  end

  # Mocks data from the VCCS API for taxi vehicle
  def mock_vehicle_details_taxi
    vehicle_details = read_file('vehicle_details_taxi_response.json')
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
  end

  # Mocks incomplete data from the VCCS API for taxi vehicle
  def mock_unrecognised_taxi_vehicle_details
    vehicle_details = read_file('vehicle_details_taxi_response.json')
    vehicle_details['fuelType'] = nil
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
  end

  # Mocks response from clean-air-zones endpoint in VCCS API
  def mock_chargeable_zones
    caz_list = read_file('caz_list_response.json')
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list['cleanAirZones'])
  end

  # Mocks response from clean-air-zones with in VCCS API with non active zones
  def mock_non_chargeable_zones
    caz_list = read_file('unchargeable_caz_list_response.json')
    allow(ComplianceCheckerApi).to receive(:clean_air_zones).and_return(caz_list['cleanAirZones'])
  end

  # Mocks response from compliance endpoint in VCCS API
  def mock_vehicle_compliance
    compliance_data = read_file('vehicle_compliance_many_charges_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_compliance)
      .and_return(compliance_data)
  end

  # Mocks response from compliance endpoint in VCCS API with zero charge for Taxidiscountcaz.
  def mock_private_car_compliance
    compliance_data = read_file('vehicle_compliance_one_charge_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_compliance)
      .and_return(compliance_data)
  end

  # Mocks response from compliance endpoint in VCCS API for compliant vehicle.
  def mock_vehicle_with_zero_charge
    compliance_data = read_file('vehicle_compliance_with_zero_charge_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_compliance)
      .and_return(compliance_data)
  end

  # Mocks a 422 exception thrown by ComplianceCheckerApi.vehicle_compliance
  def mock_undetermined_vehicle_compliance
    allow(ComplianceCheckerApi).to receive(:vehicle_compliance)
      .and_raise(BaseApi::Error422Exception.new(422, '', {}))
  end

  # Mocks compliance data for non-DVLA vehicle.
  # If +one_charge+ is set to true, it returns zero as charge for Taxidiscountcaz.
  def mock_unrecognised_compliance(one_charge: false)
    compliance_data = read_file(
      one_charge ? 'unrecognised_one_charge_response.json' : 'unrecognised_vehicle_response.json'
    )
    allow(ComplianceCheckerApi)
      .to receive(:unrecognised_compliance)
      .and_return(compliance_data)
  end

  # Returns an array with mocker zone IDs. Used to check params.
  def mocked_zone_ids
    caz_list = read_file('caz_list_response.json')['cleanAirZones']
    caz_list.map { |caz| caz['cleanAirZoneId'] }
  end

  def mock_single_caz(date = Date.current)
    details = instance_double(CazDataProvider,
                              single: OpenStruct.new(active_charge_start_date: date.to_s))
    allow(CazDataProvider).to receive(:new).and_return(details)
  end
end
