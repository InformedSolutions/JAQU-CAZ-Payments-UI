# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::AddVrn do
  subject do
    described_class.call(session: session, vrn: vrn, country: country)
  end

  let(:session) { {} }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }

  it 'sets VRN' do
    subject
    expect(session[:vehicle_details]['vrn']).to eq(vrn)
  end

  it 'sets country' do
    subject
    expect(session[:vehicle_details]['country']).to eq(country)
  end

  context 'when session is already filled' do
    let(:session) { { vehicle_details: { 'payment_id' => SecureRandom.uuid } } }

    it 'clears other keys' do
      subject
      expect(session[:vehicle_details].keys).to contain_exactly('vrn', 'country')
    end
  end
end
