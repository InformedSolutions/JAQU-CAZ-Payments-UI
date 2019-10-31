# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VehicleTypes do
  subject(:service_call) { described_class.call }

  it 'returns 7 types' do
    expect(service_call.length).to eq(7)
  end

  it 'returns objects with name and value' do
    expect(service_call.first.keys).to contain_exactly(:name, :value)
  end

  it 'sorts objects by name' do
    expect(service_call.map { |type| type[:name] })
      .to eq(service_call.map { |type| type[:name] }.sort)
  end
end
