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
end

World(MockHelper)
