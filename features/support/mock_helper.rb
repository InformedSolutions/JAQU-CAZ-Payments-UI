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
    allow(ChargeableZonesService).to receive(:call).and_return(caz_list['cleanAirZones'])
  end

  # Mocks response from unrecognised_compliance endpoint in VCCS API
  def mock_unrecognised_compliance
    unrecognised = read_file('unrecognised_response.json')
    allow(ChargeableZonesService).to receive(:call).and_return(unrecognised['charges'])
  end

  # Mocks response for a compliant vehicle
  def mock_non_chargeable_caz
    allow(ChargeableZonesService).to receive(:call).and_return([])
  end

  # Mocks response from compliance endpoint in VCCS API
  def mock_vehicle_compliance
    compliance_data = read_file('vehicle_compliance_birmingham_response.json')
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

  def mock_payment_status(success: true)
    allow(PaymentStatus).to receive(:new).and_return(
      OpenStruct.new(success?: success, user_email: 'user_email@example.com')
    )
  end

  def mock_clean_air_zones
    caz_data = read_file('caz_list_response.json')
    allow(ComplianceCheckerApi)
      .to receive(:clean_air_zones)
      .and_return(caz_data['cleanAirZones'])
  end

  private

  # Reads provided file from +spec/fixtures/files+ directory
  def read_file(filename)
    JSON.parse(File.read("spec/fixtures/files/#{filename}"))
  end
end

World(MockHelper)
