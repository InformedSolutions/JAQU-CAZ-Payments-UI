# frozen_string_literal: true

Given('I am on the select local authority page') do
  add_vrn_and_country_to_session
  mock_vehicle_details
  mock_dvla_response

  visit local_authority_charges_path
end

And('I am go the local authority page') do
  add_vrn_and_country_to_session
  mock_vehicle_details

  visit local_authority_charges_path
end

Given('I am on the daily charge page') do
  add_vrn_country_la_to_session
  mock_single_caz_request
  mock_vehicle_compliance
  mock_paid_dates

  visit daily_charge_dates_path
end

Given('My vehicle is compliant') do
  allow(ChargeableZonesService).to receive(:call).and_return([])
end

Given('My vehicle is not compliant') do
  mock_vehicle_compliance
  mock_non_dvla_response
end

When('I am only chargeable in one Clean Air Zone') do
  add_vehicle_details_to_session(add_dates: true, chargeable_zones: 2)
end

Then('I select Birmingham') do
  choose('Birmingham')
end

Then('I confirm exemption') do
  check 'confirm-exempt'
end

Then('I choose I confirm that I am not exempt') do
  check 'I confirm that I am not exempt'
end

Then('I am on the dates page') do
  mock_single_caz_request
  add_vehicle_details_to_session
  mock_paid_dates
  visit select_daily_date_dates_path
end

Then('I choose today date') do
  check 'Today'
end

Then('I have selected dates in the session') do
  expect(page.driver.request.session[:vehicle_details]['dates'])
    .to eq([Date.current.strftime('%Y-%m-%d')])
end

Then('I am on the review payment page') do
  add_vehicle_details_to_session(add_dates: true)
  mock_dvla_response
  mock_payment_creation

  visit review_payment_charges_path
end

Then('I am on the review weekly payment page') do
  add_weekly_vehicle_details_to_session
  mock_payment_creation

  visit review_payment_charges_path
end

Then('I press the Change Registration number link') do
  find('#change-vrn').click
end

Then('I press the Change Clean Air Zone link') do
  find('#change-la').click
end

Then('I press the Change Payment for link') do
  mock_vehicle_compliance
  mock_paid_dates
  mock_single_caz_request
  find('#change-dates').click
end

Then('I am go the review payment page') do
  add_vehicle_details_to_session(add_dates: true)
  visit review_payment_charges_path
end

Then('I am go the select period page') do
  visit review_payment_charges_path
end

Then('I should not see the Change Clean Air Zone link') do
  expect(page).not_to have_selector('#change-la')
end

Given('I am on the dates page with paid charge for today') do
  mock_single_caz_request(10.days.ago.to_s)
  add_vehicle_details_to_session
  mock_paid_dates(dates: [Date.current.strftime('%Y-%m-%d')])
  visit select_daily_date_dates_path
end

Given('I am on the dates page with all charges paid') do
  mock_single_caz_request
  add_vehicle_details_to_session
  mock_paid_dates(paid_period)
  visit select_daily_date_dates_path
end

Then('I should see a disabled today checkbox') do
  expect(find("input[value='#{Date.current.strftime('%Y-%m-%d')}']")).to be_disabled
end

Then('I choose a date that was already paid') do
  first("input[type='checkbox']").click
  allow(Dates::CheckPaidDaily).to receive(:call).and_return(false)
end

Given('I have not paid for any day') do
  mock_paid_dates
end

Then('I should not see the continue button') do
  expect(page).not_to have_selector('input[type="submit"]')
end

Given('I am on the pick weekly dates page with no passes available to buy') do
  add_weekly_vehicle_details_to_session
  mock_paid_dates(paid_period)
  visit select_weekly_date_dates_path
end

private

def paid_period
  {
    dates: ((Date.current - 6.days)..(Date.current + 6.days)).map(&:to_s)
  }
end
