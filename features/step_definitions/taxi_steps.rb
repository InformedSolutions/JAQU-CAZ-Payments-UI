# frozen_string_literal: true

Given('I am on the vehicle details page with taxi vehicle to check') do
  add_vrn_and_country_to_session
  mock_vehicle_details_taxi
  mock_vehicle_compliance_leeds
  mock_non_dvla_response
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

Given('I have already paid for today') do
  mock_paid_dates(dates: [Date.current.strftime('%Y-%m-%d')])
end

Given('I am on the weekly dates page') do
  add_weekly_possible_details
  visit select_weekly_date_dates_path
end

Then('I should see a disabled {string} radio') do |date|
  expect(find("input[value='#{Date.public_send(date).strftime('%Y-%m-%d')}']")).to be_disabled
end

Then('I should see an active {string} radio') do |date|
  expect(find("input[value='#{Date.public_send(date).strftime('%Y-%m-%d')}']")).not_to be_disabled
end

Then('I choose a time-frame that was already paid') do
  first("input:not([disabled])[type='radio']").click
  allow(Dates::CheckPaidDaily).to receive(:call).and_return(false)
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
