# frozen_string_literal: true

Given('I am on the vehicles details page') do
  add_vrn_and_country_to_session
  mock_vehicle_details
  mock_dvla_response

  visit details_vehicles_path
end

Then("I enter a vehicle's registration and choose UK") do
  mock_vehicle_details

  fill_in('vrn', with: vrn)
  choose('UK')
end

Then("I enter a vehicle's registration and choose Non-UK") do
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
  mock_unrecognized_vehicle

  fill_in('vrn', with: 'CU27ABA')
  choose('UK')
end

Then("I enter a compliant vehicle's registration and choose UK") do
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

Given('I am on the vehicle details page with unrecognized vehicle to check') do
  add_vrn_and_country_to_session
  mock_unrecognized_vehicle

  visit details_vehicles_path
end
