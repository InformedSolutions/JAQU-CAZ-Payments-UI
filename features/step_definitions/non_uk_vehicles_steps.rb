# frozen_string_literal: true

Given('I am on the choose type page') do
  add_vrn_to_session
  visit choose_type_non_uk_vehicles_path
end

Then('I choose Car type') do
  choose('Car')
end
