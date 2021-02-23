# frozen_string_literal: true

Given('I am on the vehicles details page') do
  add_vrn_and_country_to_session
  mock_vehicle_details
  mock_chargeable_zones
  mock_vehicle_compliance
  mock_dvla_response

  visit details_vehicles_path
end

Then("I enter a vehicle's registration and choose UK") do
  mock_vehicle_details
  mock_chargeable_zones
  mock_vehicle_compliance

  fill_in('vrn', with: vrn)
  choose('UK')
end

Then("I enter an incomplete vehicle's registration and choose UK") do
  mock_vehicle_details
  mock_chargeable_zones
  mock_vehicle_compliance
  mock_unsuccessful_dvla_response

  fill_in('vrn', with: vrn)
  choose('UK')
end

Then('I enter an unrecognised taxi registration number and choose UK') do
  mock_vehicle_not_found_in_dvla
  mock_taxi_register_details
  mock_dvla_response

  fill_in('vrn', with: vrn)
  choose('UK')
end

Then("I enter an undetermined vehicle's registration and choose UK") do
  mock_chargeable_zones
  mock_undetermined_vehicle_compliance
  mock_undetermined_vehicle_details

  fill_in('vrn', with: vrn)
  choose('UK')
end

Then("I enter an exempted non-UK vehicle's registration") do
  mock_vehicle_not_found_in_dvla
  mock_exempted_register_details
  fill_in_non_uk(vrn)
end

Then("I enter a not-exempted non-UK vehicle's registration") do
  mock_vehicle_not_found_in_dvla
  mock_unregistered_vehicle_details
  fill_in_non_uk(vrn)
end

Then("I enter an UK vehicle's registration and choose Non-UK country") do
  mock_chargeable_zones
  mock_vehicle_compliance
  mock_vehicle_details
  mock_dvla_response

  fill_in('vrn', with: vrn)
  choose('Non-UK')
end

And('I choose I confirm registration') do
  check('I confirm the number plate is correct.')
end

Then("I enter a only vehicle's registration") do
  fill_in('vrn', with: vrn)
end

Then('I choose only UK country') do
  fill_in('vrn', with: '')
  choose('UK')
end

Then('I choose that the details are incorrect') do
  mock_non_dvla_response
  choose('No')
end

Then('I choose that the details are correct') do
  choose('Yes')
end

Then("I enter a unrecognised vehicle's registration and choose UK") do
  mock_vehicle_not_found_in_dvla
  mock_unregistered_vehicle_details

  fill_in('vrn', with: 'CU27ABA')
  choose('UK')
end

Then("I enter a compliant vehicle's registration and choose UK") do
  mock_chargeable_zones
  mock_vehicle_compliance
  mock_vehicle_details
  mock_compliant_vehicle

  fill_in('vrn', with: 'CDE345')
  choose('UK')
end

Then("I enter a exempt vehicle's registration and choose UK") do
  mock_exempt_vehicle_details

  fill_in('vrn', with: 'CAS329')
  choose('UK')
end

Then("I enter a exempt vehicle's registration and choose non UK") do
  mock_exempt_vehicle_details
  fill_in_non_uk('CAS329')
end

Then('I should see {string} as vrn value') do |string|
  expect(page).to have_field('vrn', with: string)
end

Given('I am on the vehicle details page with unrecognized vehicle to check') do
  add_vrn_and_country_to_session
  mock_vehicle_not_found_in_dvla
  mock_unregistered_vehicle_details

  visit details_vehicles_path
end

Then("I enter a vehicle's registration but the zones are not active") do
  mock_non_chargeable_zones
  mock_vehicle_details
  mock_vehicle_compliance

  fill_in('vrn', with: 'CAS310')
  choose('UK')
end

private

def fill_in_non_uk(vrn)
  fill_in('vrn', with: vrn)
  choose('Non-UK')
end
