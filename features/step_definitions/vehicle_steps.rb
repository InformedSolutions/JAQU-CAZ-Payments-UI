# frozen_string_literal: true

Given('I am on the vehicles details page') do
  add_vrn_and_country_to_session
  mock_vehicle_details
  visit details_vehicles_path
end

Then("I enter a vehicle's registration and choose UK") do
  fill_in('vrn', with: vrn)
  choose('UK')
  mock_vehicle_details
end

Then("I enter a vehicle's registration and choose Non-UK") do
  fill_in('vrn', with: vrn)
  choose('Non-UK')
end

And('I choose I confirm registration') do
  check('I confirm that the registration number is correct.')
end

Then("I enter a only vehicle's registration") do
  fill_in('vrn', with: vrn)
end

Then('I choose only UK country') do
  fill_in('vrn', with: '')
  choose('UK')
end

Then('I choose that the details are incorrect') do
  choose('No')
end

Then('I choose that the details are correct') do
  choose('Yes')
end

Then("I enter a unrecognised vehicle's registration and choose UK") do
  fill_in('vrn', with: 'CU27ABA')
  choose('UK')
  mock_unrecognized_vehicle
end

Then("I enter a compliant vehicle's registration and choose UK") do
  fill_in('vrn', with: 'CDE345')
  choose('UK')
  mock_vehicle_details
end

Given('I am on the recognised page') do
  add_unrecognised_vrn_to_session
  visit details_vehicles_path
end
