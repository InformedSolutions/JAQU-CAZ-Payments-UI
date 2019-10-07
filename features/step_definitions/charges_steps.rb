# frozen_string_literal: true

Given('I am on the select local authority page') do
  add_vrn_to_session
  visit local_authority_charges_path
end

Given('My vehicle is compliant') do
  mock_compliant_vehicle
end

Given('My vehicle is not compliant') do
  mock_chargeable_caz
end

Then('I select Birmingham') do
  choose('Birmingham')
end
