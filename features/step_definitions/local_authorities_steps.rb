# frozen_string_literal: true

Given('I am on the the local authorities page') do
  add_vrn_to_session
  visit local_authorities_path
end
