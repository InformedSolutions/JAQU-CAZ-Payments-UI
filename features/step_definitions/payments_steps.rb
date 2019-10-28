# frozen_string_literal: true

Given("I'm getting redirected from GOV.UK Pay") do
  add_vehicle_details_to_session(add_payment_id: true)
  visit payments_path
end

Given('I have finished the payment successfully') do
  mock_payment_status
end

Given('I have finished the payment unsuccessfully') do
  mock_payment_status(success: false)
end

Then('I should get redirected to the GOV.UK Pay page') do
  expect(page.current_url).to eq(gov_uk_pay_url)
end

Then('I should have payment id in the session') do
  visit root_path
  expect(page.driver.request.session[:vehicle_details]['payment_id']).not_to be_nil
end
