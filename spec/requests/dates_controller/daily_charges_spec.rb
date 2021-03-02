# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - GET #daily_charge', type: :request do
  subject { get daily_charge_dates_path }

  let(:transaction_id) { SecureRandom.uuid }
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
                    additional_compliance_url: url,
                    dynamic_compliance_url: url)
  end
  let(:unrecognised_details) do
    instance_double(UnrecognisedComplianceDetails,
                    zone_name: 'Name',
                    charge: 5,
                    exemption_or_discount_url: url,
                    compliance_url: url,
                    main_info_url: url,
                    dynamic_compliance_url: url)
  end

  before do
    allow(UnrecognisedComplianceDetails)
      .to receive(:new)
      .with(la_id: zone_id)
      .and_return(unrecognised_details)
    allow(ComplianceDetails)
      .to receive(:new)
      .with(
        'vrn' => vrn,
        'country' => country,
        'la_id' => zone_id,
        'daily_charge' => 15,
        'la_name' => 'Taxidiscountcaz',
        'undetermined_taxi' => false,
        'weekly_possible' => false,
        'weekly_charge_today' => false,
        'weekly_dates' => []
      ).and_return(details)
  end

  context 'with undetermined_taxi set in session' do
    before do
      add_details_to_session(
        details: { vrn: vrn, country: country, la_id: zone_id, undetermined_taxi: true }
      )
    end

    it 'calls UnrecognisedComplianceDetails with right params' do
      subject
      expect(UnrecognisedComplianceDetails).to have_received(:new).with(la_id: zone_id)
    end

    it 'returns a success response' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'sets :undetermined_taxi variable' do
      subject
      expect(assigns(:undetermined_taxi)).to be_truthy
    end
  end

  context 'with VRN and LA in the session' do
    before do
      add_details_to_session(
        details: { vrn: vrn, country: country, la_id: zone_id }
      )
    end

    it 'call ComplianceDetails with right params' do
      subject
      expect(ComplianceDetails).to have_received(:new)
        .with(
          'vrn' => vrn,
          'country' => country,
          'la_id' => zone_id,
          'daily_charge' => 15,
          'la_name' => 'Taxidiscountcaz',
          'undetermined_taxi' => false,
          'weekly_possible' => false,
          'weekly_charge_today' => false,
          'weekly_dates' => []
        )
    end

    it 'returns a success response' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'does not set :undetermined_taxi variable' do
      subject
      expect(assigns(:undetermined_taxi)).to be_falsey
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end
end
