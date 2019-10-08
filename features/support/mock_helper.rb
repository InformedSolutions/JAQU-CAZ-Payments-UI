# frozen_string_literal: true

module MockHelper
  def mock_chargeable_caz
    caz_list = JSON.parse(File.read('spec/fixtures/files/caz_list_response.json'))
    allow(ComplianceCheckerApi)
      .to receive(:chargeable_zones)
      .and_return(caz_list['cleanAirZones'])
  end

  def mock_compliant_vehicle
    allow(ComplianceCheckerApi).to receive(:chargeable_zones).and_return([])
  end

  def mock_vehicle_compliance
    compliance_data = JSON.parse(File.read('spec/fixtures/files/vehicle_compliance_response.json'))
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_compliance)
      .and_return(compliance_data)
  end
end

World(MockHelper)
