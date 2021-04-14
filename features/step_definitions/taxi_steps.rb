# frozen_string_literal: true

Given('I am on the vehicle details page with taxi vehicle to check') do
  add_vrn_and_country_to_session
  mock_vehicle_details_taxi
  mock_chargeable_zones
  mock_vehicle_compliance_discount_taxi
  mock_non_dvla_response
  mock_single_caz_request_for_charge_start_date
  visit details_vehicles_path
end

Given('I am on the vehicle details page with unrecognized taxi vehicle to check') do
  add_vrn_and_country_to_session
  mock_incomplete_vehicle_details_taxi
  mock_chargeable_zones
  mock_undetermined_vehicle_compliance
  mock_unrecognised_compliance
  mock_non_dvla_response
  mock_single_caz_request_for_charge_start_date
  visit details_vehicles_path
end

Then('I select Taxidiscountcaz') do
  choose('Taxidiscountcaz')
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
  mock_weekly_details
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
  weekly_fill_in_date(day: (Time.current + 9.days).day)
end

And('I fill in an invalid second week start date') do
  mock_already_selected_weekly_date
  weekly_fill_in_date(year: 1820)
end

Then('I want to change selected dates') do
  find('#change-dates').click
end

Then('I want to change selected dates') do
  find('#change-dates').click
end

# Mocks taxi response from vehicle details endpoint in VCCS API
def mock_vehicle_details_taxi
  vehicle_details = read_file('vehicle_details_taxi_response.json')
  allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
end

def mock_incomplete_vehicle_details_taxi
  vehicle_details = read_file('vehicle_details_taxi_response.json')
  vehicle_details['fuelType'] = nil
  allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
end

def mock_unrecognised_compliance
  unrecognised_compliance = read_file('unrecognised_vehicle_response.json')
  allow(ComplianceCheckerApi).to receive(:unrecognised_compliance).and_return(unrecognised_compliance)
end

# Mocks response from compliance endpoint in VCCS API
def mock_vehicle_compliance_discount_taxi
  compliance_data = read_file('vehicle_compliance_discount_taxi_response.json')
  allow(ComplianceCheckerApi).to receive(:vehicle_compliance).and_return(compliance_data)
end

# Mocks Dates::ValidateSelectedWeeklyDate to pass validation and save dates to session
def mock_validate_selected_weekly_date(second_week_selected: false)
  allow_any_instance_of(Dates::ValidateSelectedWeeklyDate).to receive(:already_selected?).and_return(false)

  allow_any_instance_of(Dates::ValidateSelectedWeeklyDate).to receive(:add_dates_to_session) do
    mock_add_dates_to_session(second_week_selected)
  end
end

# Mocks Dates::ValidateSelectedWeeklyDate.already_selected? to pass validation
def mock_already_selected_weekly_date
  details = instance_double(Dates::ValidateSelectedWeeklyDate,
                            start_date: '2019-11-1',
                            error: I18n.t('already_selected', scope: 'dates.weekly'),
                            valid?: false)
  allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)
end

# Mocks paid dates
def mock_weekly_details
  allow(Dates::CheckPaidWeekly).to receive(:call).and_return(true)
  add_weekly_vehicle_details_to_session
end

# Mock implementation for Dates::ValidateSelectedWeeklyDate.add_dates_to_session
def mock_add_dates_to_session(second_week_selected)
  if second_week_selected
    future_date = Time.current + 9.days
    add_to_session(second_week_start_date: "#{future_date.year}-#{future_date.month}-#{future_date.day}")
  else
    add_to_session(first_week_start_date: "#{Time.current.year}-#{Time.current.month}-#{Time.current.day}")
  end
end

# Fills in the 3 date inputs
def weekly_fill_in_date(day: Time.current.day, month: Time.current.month, year: Time.current.year)
  fill_in('date_day', with: day)
  fill_in('date_month', with: month)
  fill_in('date_year', with: year)
end
