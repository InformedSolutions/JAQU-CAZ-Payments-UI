# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentDetails, type: :model do
  subject(:details) { described_class.new(session_details) }

  let(:session_details) do
    {
      'vrn' => vrn,
      'la_id' => zone_id,
      'external_id' => id,
      'user_email' => email,
      'payment_reference' => ref,
      'la_name' => zone_name,
      'dates' => dates,
      'total_charge' => charge,
      'chargeable_zones' => 2
    }
  end

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:zone_name) { 'Leeds' }
  let(:ref) { SecureRandom.uuid }
  let(:id) { SecureRandom.uuid }
  let(:email) { 'test@example.com' }
  let(:charge) { 15 }
  let(:dates) { %w[2019-11-01 2019-11-02 2019-11-03] }

  it { expect(details.vrn).to eq(vrn) }
  it { expect(details.la_name).to eq(zone_name) }
  it { expect(details.user_email).to eq(email) }
  it { expect(details.reference).to eq(ref) }
  it { expect(details.external_id).to eq(id) }
  it { expect(details.dates).to eq(dates) }
  it { expect(details.total_charge).to eq(charge) }
  it { expect(details.chargeable_zones_count).to eq(2) }

  describe '.compliance_details' do
    it 'calls ComplianceDetails model' do
      allow(ComplianceDetails)
        .to receive(:new)
        .and_return(instance_double(ComplianceDetails))
      expect(ComplianceDetails).to receive(:new).with(session_details)
      details.compliance_details
    end

    it 'returns ComplianceDetails instance' do
      expect(details.compliance_details).to be_a(ComplianceDetails)
    end
  end
end
