# frozen_string_literal: true

##
# Module used to mock external calls for cucumber tests
#
module MockHelper
  # Returns URL
  def gov_uk_pay_url
    'https://www.payments.service.gov.uk/'
  end

  # Mocks response from clean-air-zones endpoint in VCCS API
  def mock_chargeable_caz
    caz_list = read_file('caz_list_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:chargeable_zones)
      .and_return(caz_list['cleanAirZones'])
  end

  # Mocks response for a compliant vehicle
  def mock_compliant_vehicle
    allow(ComplianceCheckerApi)
      .to receive(:chargeable_zones)
      .and_return([])
  end

  # Mocks response from compliance endpoint in VCCS API
  def mock_vehicle_compliance
    compliance_data = read_file('vehicle_compliance_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_compliance)
      .and_return(compliance_data)
  end

  # Mocks response from vehicle details endpoint in VCCS API
  def mock_vehicle_details
    vehicle_details = read_file('vehicle_details_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_details)
      .and_return(vehicle_details)
  end

  # Mock response from vehicle details endpoint in VCCS API for not found in DVLA vehicle
  def mock_unrecognized_vehicle
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_details)
      .and_raise(BaseApi:: Error404Exception.new(404, '', {}))
  end

  def mock_payment_creation
    allow(Payment).to receive(:new).and_return(
      OpenStruct.new(payment_id: SecureRandom.uuid, gov_uk_pay_url: gov_uk_pay_url)
    )
  end

  private

  # Reads provided file from +spec/fixtures/files+ directory
  def read_file(filename)
    JSON.parse(File.read("spec/fixtures/files/#{filename}"))
  end
end

World(MockHelper)
