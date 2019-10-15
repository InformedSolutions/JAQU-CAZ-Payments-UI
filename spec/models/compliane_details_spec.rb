# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ComplianceDetails, type: :model do
  subject(:details) { described_class.new(vrn, zone_id) }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:outcomes) do
    [{ 'name' => name, 'charge' => '5', 'urls' => { 'exemptionOrDiscount' => url } }]
  end
  let(:name) { 'Leeds' }
  let(:url) { 'www.wp.pl' }

  before do
    allow(ComplianceCheckerApi)
      .to receive(:vehicle_compliance)
      .with(vrn, zone_id)
      .and_return('complianceOutcomes' => outcomes)
  end

  describe '.zone_name' do
    it 'returns CAZ name' do
      expect(details.zone_name).to eq(name)
    end
  end

  describe '.charge' do
    it 'returns formatted charge value' do
      expect(details.charge).to eq('5')
    end
  end

  describe '.exemption_or_discount_url' do
    it 'returns URL' do
      expect(details.zone_name).to eq(name)
    end
  end
end
