# frozen_string_literal: true

require 'rails_helper'

describe SessionManipulation::SetIncorrect do
  subject { described_class.call(session: session) }

  let(:session) { { vehicle_details: details } }
  let(:details) { { 'vrn' => vrn, 'country' => country } }
  let(:vrn) { 'CU123AB' }
  let(:country) { 'UK' }

  before { subject }

  it 'sets incorrect' do
    expect(session[:vehicle_details]['incorrect']).to be_truthy
  end

  context 'when session is already filled with more data' do
    let(:details) do
      { 'vrn' => vrn, 'country' => country, 'la_name' => 'Taxidiscountcaz' }
    end

    it 'clears keys from next steps' do
      expect(session[:vehicle_details].keys)
        .to contain_exactly('vrn', 'country', 'incorrect')
    end

    context 'when vehicle is set to be unrecognized' do
      let(:details) do
        { 'vrn' => vrn, 'country' => country, 'unrecognised' => true }
      end

      it 'clears keys from next steps' do
        expect(session[:vehicle_details].keys)
          .to contain_exactly('vrn', 'country', 'incorrect')
      end
    end
  end
end
