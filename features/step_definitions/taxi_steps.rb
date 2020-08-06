# frozen_string_literal: true

Given('I am on the vehicle details page with taxi vehicle to check') do
  add_vrn_and_country_to_session
  mock_vehicle_details_taxi
  mock_vehicle_compliance_leeds
  mock_non_dvla_response
  mock_single_caz_request_for_charge_start_date
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

Then('I select any available day') do
  mock_paid_dates(dates: [])
  first("input:not([disabled])[type='radio']").choose
end

Given('I have already paid for today') do
  mock_paid_dates(dates: [today_formatted])
end

Given('I am not paid for today') do
  mock_paid_dates(dates: [])
end

Given('I have already paid for tomorrow') do
  mock_paid_dates(dates: [Date.current.tomorrow.strftime('%Y-%m-%d')])
end

Given('I am on the weekly dates page') do
  mock_single_caz_request_for_charge_start_date(Date.current - 7.days)
  mock_paid_dates(dates: [today_formatted])
  add_weekly_possible_details
  mock_validate_selected_weekly_date
  visit select_weekly_date_dates_path
end

Given('I am on the weekly dates page when d-day was yesterday and today day is paid') do
  mock_single_caz_request_for_charge_start_date(Date.current.yesterday)
  mock_paid_dates(dates: [today_formatted])
  add_weekly_possible_details
  visit select_weekly_date_dates_path
end

Given('I am on the weekly dates page when d-day will be tomorrow') do
  mock_single_caz_request_for_charge_start_date(Date.current.tomorrow)
  mock_paid_dates
  add_weekly_possible_details
  visit select_weekly_date_dates_path
end

Given('I am on the weekly dates page when d-day was 7 days ago and today day is paid') do
  mock_single_caz_request_for_charge_start_date(Date.current - 7.days)
  mock_paid_dates(dates: [today_formatted])
  add_weekly_possible_details
  visit select_weekly_date_dates_path
end

Given('I am on the weekly dates page when d-day was 7 days ago and today day is not paid') do
  mock_single_caz_request_for_charge_start_date(Date.current - 7.days)
  mock_paid_dates
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

And('I fill in an available week start date') do
  add_to_session(first_week_start_date: '2020-05-01')
  visit select_weekly_date_dates_path
  weekly_fill_in_date
end

And('I fill in an available second week start date') do
  add_to_session(second_week_start_date: '2020-05-08')
  visit select_second_weekly_date_dates_path
  weekly_fill_in_date
end

And('I fill in an invalid second week start date') do
  mock_already_selected_weekly_date
  weekly_fill_in_date
end

Then('I want to change selected dates') do
  find('#change-dates').click
end

# Mocks taxi response from vehicle details endpoint in VCCS API
def mock_vehicle_details_taxi
  vehicle_details = read_file('vehicle_details_taxi_response.json')
  allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
end

# Mocks response from compliance endpoint in VCCS API
def mock_vehicle_compliance_leeds
  compliance_data = read_file('vehicle_compliance_leeds_response.json')
  allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance_data)
end

def mock_validate_selected_weekly_date
  details = instance_double(Dates::ValidateSelectedWeeklyDate,
                            start_date: '2019-11-1',
                            valid?: true,
                            add_dates_to_session: true)
  allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)
  allow(Dates::CheckPaidWeekly).to receive(:call).and_return(true)
  add_weekly_vehicle_details_to_session
end

def mock_already_selected_weekly_date
  details = instance_double(Dates::ValidateSelectedWeeklyDate,
                            start_date: '2019-11-1',
                            error: I18n.t('already_selected', scope: 'dates.weekly'),
                            valid?: false)
  allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)
end

def weekly_fill_in_date
  fill_in('date_day', with: '1')
  fill_in('date_month', with: '5')
  fill_in('date_year', with: '2020')
end
