# frozen_string_literal: true

##
# Module used to mock external calls for cucumber tests
#
module MockHelper
  # Returns URL
  def gov_uk_pay_url
    'https://www.payments.service.gov.uk/'
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

  # Mocks exempt vehicle details endpoint in VCCS API
  def mock_exempt_vehicle_details
    vehicle_details = read_file('vehicle_details_exempt_response.json')
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
  end

  def mock_dvla_response
    response = read_file('vehicle_compliance_birmingham_response.json')
    dvla_response = response['complianceOutcomes'].map { |caz_data| Caz.new(caz_data) }

    allow(ChargeableZonesService)
      .to receive(:call)
      .and_return(dvla_response)
  end

  def mock_non_dvla_response
    response = read_file('caz_list_response.json')
    non_dvla_response = response['cleanAirZones'].map { |caz_data| Caz.new(caz_data) }

    allow(ChargeableZonesService)
      .to receive(:call)
      .and_return(non_dvla_response)
  end

  def mock_compliant_vehicle
    allow(ChargeableZonesService)
      .to receive(:call)
      .and_return([])
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

  def mock_paid_dates(dates: [])
    allow(PaymentsApi).to receive(:paid_payments_dates).and_return(dates)
  end

  private

  # Reads provided file from +spec/fixtures/files+ directory
  def read_file(filename)
    JSON.parse(File.read("spec/fixtures/files/#{filename}"))
  end
end

World(MockHelper)
