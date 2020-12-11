# frozen_string_literal: true

require 'rails_helper'

describe Caz, type: :model do
  subject(:caz) { described_class.new(data) }

  let(:data) do
    {
      'name' => name,
      'cleanAirZoneId' => id,
      'boundaryUrl' => url,
      'activeChargeStartDate' => active_charge_start_date
    }
  end
  let(:name) { 'Birmingham' }
  let(:id) { SecureRandom.uuid }
  let(:url) { 'www.example.com' }
  let(:active_charge_start_date) { '2020-05-01' }

  describe '.id' do
    it 'returns a proper id' do
      expect(caz.id).to eq(id)
    end
  end

  describe '.name' do
    it 'returns a proper name' do
      expect(caz.name).to eq(name)
    end
  end

  describe '.boundary_url' do
    it 'returns a proper url' do
      expect(caz.boundary_url).to eq(url)
    end
  end

  describe '.active_charge_start_date' do
    it 'returns a proper date' do
      expect(caz.active_charge_start_date).to eq(active_charge_start_date)
    end
  end
end
