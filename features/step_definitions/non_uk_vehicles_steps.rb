# frozen_string_literal: true

Given('I am on the choose type page for non-UK vehicle') do
  add_vrn_and_non_uk_to_session
  visit choose_type_non_uk_vehicles_path
end

Then('I choose Car type') do
  choose('Car')
  mock_chargeable_caz
end
