# frozen_string_literal: true

Then('I should have payment id in the session') do
  expect(page.driver.request.session[:vehicle_details]['payment_id']).not_to be_nil
end
