# frozen_string_literal: true

Given(/^I am on the home page$/) do
  visit '/'
end

Then('I press the Start now button') do
  click_link 'Start now'
end

Then('I should see {string}') do |string|
  expect(page).to have_content(string)
end
