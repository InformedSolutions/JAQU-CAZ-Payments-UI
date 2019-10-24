# frozen_string_literal: true

Then('I should get redirected to the GOV.UK Pay page') do
  expect(page.current_url).to eq(gov_uk_pay_url)
end

Then('I should have payment id in the session') do
  visit payments_path
  expect(page.driver.request.session[:vehicle_details]['payment_id']).not_to be_nil
end
