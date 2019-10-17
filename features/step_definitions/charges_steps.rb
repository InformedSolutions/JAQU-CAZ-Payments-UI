# frozen_string_literal: true

Given('I am on the select local authority page') do
  add_vrn_and_country_to_session
  mock_vehicle_details
  visit local_authority_charges_path
end

Given('I am on the daily charge page') do
  mock_vehicle_compliance
  add_vrn_country_la_to_session
  visit daily_charge_charges_path
end

Given('My vehicle is compliant') do
  mock_compliant_vehicle
end

Given('My vehicle is not compliant') do
  mock_chargeable_caz
  mock_vehicle_compliance
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
  add_vehicle_details_to_session
  visit dates_charges_path
end

Then('I choose today date') do
  check 'Today'
end

Then('I am on the review payment page') do
  add_vehicle_details_to_session
  visit review_payment_charges_path
end

Then('I press the Change Registration number link') do
  find('#change-vrn').click
end

Then('I press the Change Clean Air Zone link') do
  find('#change-la').click
end

Then('I press the Change Payment for link') do
  find('#change-dates').click
end

Then('I am go the review payment page') do
  add_vehicle_details_to_session
  visit review_payment_charges_path
end
