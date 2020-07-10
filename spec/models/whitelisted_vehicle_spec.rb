# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WhitelistedVehicle, type: :model do
  subject(:whitelisted_vehicle) { described_class.new(vrn) }

  let(:vrn) { 'CU57ABC' }

  let(:response) do
    {
      'vrn' => vrn
    }
  end

  before do
    allow(ComplianceCheckerApi).to receive(:whitelisted_vehicle).with(vrn).and_return(response)
  end

  describe '.exempt?' do
    context 'when API returns whitelisted vehicle' do
      it 'returns true' do
        expect(subject.exempt?).to eq(true)
      end
    end

    context 'when API returns status 404' do
      before do
        allow(ComplianceCheckerApi).to receive(:whitelisted_vehicle)
          .and_raise(BaseApi::Error404Exception.new(404, '', {}))
      end

      it 'returns false' do
        expect(subject.exempt?).to eq(false)
      end
    end
  end
end
