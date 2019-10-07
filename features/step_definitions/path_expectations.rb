# frozen_string_literal: true

def expect_path(path)
  expect(page).to have_current_path(path)
end

Then('I should be on the enter details page') do
  expect_path(enter_details_vehicles_path)
end

Then('I should be on the vehicle details page') do
  expect_path(details_vehicles_path)
end

Then('I should be on the incorrect details page') do
  expect_path(incorrect_details_vehicles_path)
end

Then('I should be on the choose type page') do
  expect_path(choose_type_non_uk_vehicles_path)
end

Then('I should be on the compliant vehicle page') do
  expect_path(compliant_vehicles_path)
end

Then('I should be on the non UK page') do
  expect_path(non_uk_vehicles_path)
end

Then('I should be on the local authorities page') do
  expect_path(local_authority_charges_path)
end

Then('I should be on the pick dates page') do
  expect_path(dates_charges_path)
end
