# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - GET #weekly_charge', type: :request do
  subject { get weekly_charge_dates_path }

  let(:transaction_id) { SecureRandom.uuid }
  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:url) { 'www.wp.pl' }
  let(:details) do
    instance_double(ComplianceDetails,
                    zone_name: 'Taxidiscountcaz',
                    charge: 50,
                    exemption_or_discount_url: url,
                    compliance_url: url,
                    additional_compliance_url: url,
                    dynamic_compliance_url: url)
  end

  before do
    allow(ComplianceDetails)
      .to receive(:new)
      .with(
        'vrn' => vrn,
        'country' => country,
        'la_id' => zone_id,
        'daily_charge' => kind_of(Numeric),
        'la_name' => kind_of(String),
        'undetermined_taxi' => false,
        'weekly_possible' => true,
        'weekly_charge_today' => false,
        'weekly_dates' => []
      ).and_return(details)
  end

  context 'with VRN and LA in the session' do
    before do
      add_details_to_session(
        details: { vrn: vrn, country: country, la_id: zone_id },
        weekly_possible: true
      )
    end

    it 'call ComplianceDetails with right params' do
      subject
      expect(ComplianceDetails).to have_received(:new)
        .with(
          'vrn' => vrn,
          'country' => country,
          'la_id' => zone_id,
          'daily_charge' => kind_of(Numeric),
          'la_name' => kind_of(String),
          'undetermined_taxi' => false,
          'weekly_possible' => true,
          'weekly_charge_today' => false,
          'weekly_dates' => []
        )
    end

    it 'returns a success response' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session(vrn: vrn, country: country)
    end

    it_behaves_like 'la is missing'
  end

  context 'when Taxidiscountcaz discount is NOT possible' do
    it_behaves_like 'not allowed Taxidiscountcaz discount'
  end
end
