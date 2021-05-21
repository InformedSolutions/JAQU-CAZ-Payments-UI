# frozen_string_literal: true

require 'rails_helper'

describe CazDataProvider do
  before { mock_chargeable_zones }

  describe '.single' do
    subject { described_class.new.single(zone_id: zone_id) }

    let(:zone_id) { '7d0c4240-1618-446b-bde2-2f3458c8a520' }

    it 'returns a single Caz object' do
      expect(subject).to be_a(Caz)
    end
  end

  describe '.displayable' do
    subject { described_class.new.displayable }

    it 'returns collection of Caz objects' do
      expect(subject).to all(be_a(Caz))
    end

    it 'filters out non-displayable CAZes' do
      expect(subject.count).to eq(1)
    end
  end
end
