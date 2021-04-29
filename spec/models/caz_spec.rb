# frozen_string_literal: true

require 'rails_helper'

describe Caz, type: :model do
  subject(:caz) { described_class.new(data) }

  let(:data) do
    {
      'name' => name,
      'cleanAirZoneId' => id,
      'boundaryUrl' => url,
      'privacyPolicyUrl' => url,
      'activeChargeStartDate' => active_charge_start_date,
      'activeChargeStartDateText' => active_charge_start_date_text,
      'displayOrder' => display_order,
      'displayFrom' => display_from,
      'operatorName' => operator_name
    }
  end
  let(:name) { 'Birmingham' }
  let(:id) { SecureRandom.uuid }
  let(:url) { 'www.example.com' }
  let(:active_charge_start_date) { '2020-05-01' }
  let(:active_charge_start_date_text) { 'Q2 2020' }
  let(:display_order) { 1 }
  let(:display_from) { '2020-01-01' }
  let(:operator_name) { 'Birmingham City Council' }

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

  describe '.active_charge_start_date_text' do
    it 'returns a proper text' do
      expect(caz.active_charge_start_date_text).to eq(active_charge_start_date_text)
    end
  end

  describe '.display_order' do
    it 'returns a proper value' do
      expect(caz.display_order).to eq(display_order)
    end
  end

  describe '.display_from' do
    it 'returns a proper date' do
      expect(caz.display_from).to eq(display_from)
    end
  end

  describe '.privacy_policy_url' do
    it 'returns a proper url' do
      expect(caz.privacy_policy_url).to eq(url)
    end
  end

  describe '.operator_name' do
    it 'returns a proper value' do
      expect(caz.operator_name).to eq(operator_name)
    end
  end
end
