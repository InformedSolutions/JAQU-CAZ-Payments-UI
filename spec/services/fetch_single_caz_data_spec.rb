# frozen_string_literal: true

require 'rails_helper'

describe FetchSingleCazData do
  subject { described_class.call(zone_id: zone_id) }

  let(:zone_id) { '7d0c4240-1618-446b-bde2-2f3458c8a520' }

  describe '.call' do
    before { mock_chargeable_zones }

    it 'returns Caz instance' do
      expect(subject).to be_a(Caz)
    end

    it 'calls ComplianceCheckerApi.clean_air_zones' do
      subject
      expect(ComplianceCheckerApi).to have_received(:clean_air_zones)
    end
  end
end
