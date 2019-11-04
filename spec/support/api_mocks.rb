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

  # Mocks response from clean-air-zones endpoint in VCCS API
  def mock_chargeable_zones
    caz_list = read_file('caz_list_response.json')
    allow(ComplianceCheckerApi).to receive(:chargeable_zones).and_return(caz_list['cleanAirZones'])
  end

  # Mocks response from compliance endpoint in VCCS API
  def mock_vehicle_compliance
    compliance_data = read_file('vehicle_compliance_birmingham_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_compliance)
      .and_return(compliance_data)
  end

  def mock_vehicle_with_zero_charge
    compliance_data = read_file('vehicle_compliance_with_zero_charge_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_compliance)
      .and_return(compliance_data)
  end
end
