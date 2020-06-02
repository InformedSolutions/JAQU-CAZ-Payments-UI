# frozen_string_literal: true

Then('I should see {string} title') do |string|
  expect(page).to have_title(string)
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end

Then('I should not see {string}') do |string|
  expect(page).not_to have_content(string)
end

Then('I press {string} link') do |string|
  click_link(string)
end

Then('I press the Continue') do
  click_on('Continue')
end

Then('I press the Confirm') do
  click_button('Confirm')
end

Then('I press {string} footer link') do |string|
  within('footer.govuk-footer') do
    click_link(string)
  end
end

Given('I am on the enter details page') do
  visit enter_details_vehicles_path
end

Then('I select {string}') do |string|
  choose(string)
end
