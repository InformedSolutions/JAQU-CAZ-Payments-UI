# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetType do
  subject { described_class.call(session: session, type: type) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => vrn, 'country' => country, 'unrecognised' => true } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }
  let(:type) { 'Car' }

  it 'sets type' do
    subject
    expect(session[:vehicle_details]['type']).to eq(type)
  end

  context 'when session is already filled with more data' do
    let(:details) do
      {
        'vrn' => vrn,
        'country' => country,
        'unrecognised' => true,
        'payment_id' => SecureRandom.uuid
      }
    end

    it 'clears keys from next steps' do
      subject
      expect(session[:vehicle_details].keys)
        .to contain_exactly('vrn', 'country', 'unrecognised', 'type')
    end
  end
end
