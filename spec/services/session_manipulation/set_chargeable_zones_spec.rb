# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionManipulation::SetChargeableZones do
  subject(:service) do
    described_class.call(session: session, chargeable_zones: zones_count)
  end

  let(:session) { { vehicle_details: details } }
  let(:details) do
    { 'vrn' => vrn, 'country' => country, 'unrecognised' => true, 'type' => type }
  end
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }
  let(:type) { 'Car' }
  let(:zones_count) { 2 }

  it 'sets chargeable_zones' do
    service
    expect(session[:vehicle_details]['chargeable_zones']).to eq(zones_count)
  end

  context 'when session is already filled with more data' do
    let(:details) do
      {
        'vrn' => vrn,
        'country' => country,
        'unrecognised' => true,
        'payment_id' => SecureRandom.uuid,
        'type' => type
      }
    end

    it 'clears keys from next steps' do
      service
      expect(session[:vehicle_details].keys)
        .to contain_exactly('vrn', 'country', 'unrecognised', 'type', 'chargeable_zones')
    end
  end
end
