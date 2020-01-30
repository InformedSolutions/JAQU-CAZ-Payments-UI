# frozen_string_literal: true

Given(/^I am on the home page$/) do
  visit '/'
end

Then('I press the Start now button') do
  click_link 'Start now'
end

Given('I am on the refunds scenarios page') do
  visit scenarios_refunds_path
end
