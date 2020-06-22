# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegisterDetails, type: :model do
  subject { described_class.new(vrn) }

  let(:vrn) { 'CAS310' }

  before do
    response = { 'registerCompliant' => true, 'registerExempt' => true }
    allow(ComplianceCheckerApi).to receive(:register_details).and_return(response)
  end

  describe '.register_compliant?' do
    it 'returns a proper register_compliant' do
      expect(subject.register_compliant?).to eq true
    end
  end

  describe '.register_exempt?' do
    it 'returns a proper register_exempt' do
      expect(subject.register_exempt?).to eq true
    end
  end
end
