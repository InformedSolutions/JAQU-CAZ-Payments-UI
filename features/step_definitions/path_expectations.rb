# frozen_string_literal: true

def expect_path(path)
  expect(page).to have_current_path(path, ignore_query: true)
end

Then('I should be on the start page') do
  expect_path(root_path)
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

Then('I should be on the vehicle details incomplete page') do
  expect_path(not_determined_vehicles_path)
end

Then('I should be on the choose type page') do
  expect_path(choose_type_non_dvla_vehicles_path)
end

Then('I should be on the compliant vehicle page') do
  expect_path(compliant_vehicles_path)
end

Then('I should be on the non UK page') do
  expect_path(non_dvla_vehicles_path)
end

Then('I should be on the local authorities page') do
  expect_path(local_authority_charges_path)
end

Then('I should be on the daily charge page') do
  expect_path(daily_charge_dates_path)
end

Then('I should be on the pick daily dates page') do
  expect_path(select_daily_date_dates_path)
end

Then('I should be on the weekly charge page') do
  expect_path(weekly_charge_dates_path)
end

Then('I should be on the pick weekly dates page') do
  expect_path(select_weekly_date_dates_path)
end

Then('I should be on the pick second weekly dates page') do
  expect_path(select_second_weekly_date_dates_path)
end

Then('I should be on the pick weekly charge period page') do
  expect_path(select_weekly_period_dates_path)
end

Then('I should be on the select period page') do
  expect_path(select_period_dates_path)
end

Then('I should be on the review your payment page') do
  expect_path(review_payment_charges_path)
end

Then('I should be on the unrecognised page') do
  expect_path(unrecognised_vehicles_path)
end

Then('I should be on the payments page') do
  expect_path(payments_path)
end

Then('I should be on the successful payments page') do
  expect_path(success_payments_path)
end

Then('I should be on the failed payments page') do
  expect_path(failure_payments_path)
end

Then('I should be on the cookies page') do
  expect_path(cookies_path)
end

Then('I should be on the privacy notice page') do
  expect_path(privacy_notice_path)
end

Then('I should be on the accessibility statement page') do
  expect_path(accessibility_statement_path)
end
