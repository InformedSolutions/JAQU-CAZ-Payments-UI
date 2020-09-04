# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #daily_charge', type: :request do
  subject { get daily_charge_dates_path }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:url) { 'www.wp.pl' }
  let(:details) do
    instance_double(ComplianceDetails,
                    zone_name: 'Name',
                    charge: 5,
                    exemption_or_discount_url: url,
                    compliance_url: url,
                    main_info_url: url,
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
        'weekly_possible' => false,
        'weekly_charge_today' => false
      ).and_return(details)
  end

  context 'with VRN and LA in the session' do
    before do
      add_details_to_session(
        details: { vrn: vrn, country: country, la_id: zone_id }
      )
    end

    it 'call ComplianceDetails with right params' do
      expect(ComplianceDetails)
        .to receive(:new)
        .with(
          'vrn' => vrn,
          'country' => country,
          'la_id' => zone_id,
          'daily_charge' => kind_of(Numeric),
          'la_name' => kind_of(String),
          'weekly_possible' => false,
          'weekly_charge_today' => false
        )
      subject
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
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end
end
