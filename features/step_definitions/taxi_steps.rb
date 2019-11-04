# frozen_string_literal: true

Given('I am on the vehicle details page with taxi vehicle to check') do
  add_vrn_and_country_to_session
  mock_vehicle_details_taxi
  mock_vehicle_compliance_leeds
  visit details_vehicles_path
end

Then('I select Leeds') do
  choose('Leeds')
end

Then('I select Pay for 7 days') do
  choose('Pay for 7 days (£50.00)')
end

Then('I select Pay for 1 day') do
  choose('Pay for 1 day (£12.50)')
end

Then('I select Today') do
  choose('Today')
end

# Mocks taxi response from vehicle details endpoint in VCCS API
def mock_vehicle_details_taxi
  vehicle_details = read_file('vehicle_details_taxi_response.json')
  allow(ComplianceCheckerApi)
    .to receive(:vehicle_details)
    .and_return(vehicle_details)
end

# Mocks response from compliance endpoint in VCCS API
def mock_vehicle_compliance_leeds
  compliance_data = read_file('vehicle_compliance_leeds_response.json')
  allow(ComplianceCheckerApi)
    .to receive(:vehicle_compliance)
    .and_return(compliance_data)
end
