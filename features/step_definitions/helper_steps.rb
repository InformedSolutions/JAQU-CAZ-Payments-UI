# frozen_string_literal: true

Then('I should see {string} title') do |string|
  expect(page).to have_title(string)
end

Then('I should see the Vehicle Checker page') do
  expect(page).to have_current_path(enter_details_vehicle_checkers_path)
end
