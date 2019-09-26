# frozen_string_literal: true

Then("I enter a vehicle's registration and choose UK") do
  fill_in('vrn', with: vrn)
  choose('UK')
end

Then("I enter a vehicle's registration and choose Non-UK") do
  fill_in('vrn', with: vrn)
  choose('Non-UK')
end

Then('I press the Continue') do
  click_button 'Continue'
end

And('I am on the non UK page') do
  expect(page).to have_current_path(non_uk_vehicles_path)
end

And('I choose I confirm registration') do
  check('I confirm that the registration number is correct.')
end

Then("I enter a only vehicle's registration") do
  fill_in('vrn', with: vrn)
end

Then('I choose only UK country') do
  choose('UK')
end
