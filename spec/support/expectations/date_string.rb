# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :be_a_date_string do
  match do |actual|
    actual.to_date.class == Date
  rescue ArgumentError
    false
  end
end
