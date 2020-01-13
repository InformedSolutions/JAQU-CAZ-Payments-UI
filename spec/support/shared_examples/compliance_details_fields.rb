# frozen_string_literal: true

RSpec.shared_examples 'compliance details fields' do
  describe '.zone_name' do
    it 'returns CAZ name' do
      expect(details.zone_name).to eq(name)
    end
  end

  describe '.charge' do
    it 'returns charge value' do
      expect(details.charge).to eq(charge)
    end
  end

  describe '.tariff_code' do
    it 'returns tariff' do
      expect(details.tariff_code).to eq(tariff)
    end
  end
end
