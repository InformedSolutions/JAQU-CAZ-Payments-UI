# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - POST #submit_local_authority', type: :request do
  subject do
    post submit_local_authority_charges_path, params: { 'local-authority': zone_id }
  end

  let(:zone_id) { SecureRandom.uuid }
  let(:zone_name) { 'Leeds' }
  let(:charge) { 50 }
  let(:tariff) { 'BCC01-private_car' }

  context 'with VRN set' do
    before do
      add_vrn_to_session
      details = instance_double(ComplianceDetails,
                                zone_name: zone_name,
                                charge: charge,
                                tariff_code: tariff)
      allow(ComplianceDetails).to receive(:new).and_return(details)
    end

    context 'with selected zone' do
      it 'returns redirect to #daily_charge' do
        expect(subject).to redirect_to(daily_charge_dates_path)
      end

      it 'sets la_id in the session' do
        subject
        expect(session.dig(:vehicle_details, 'la_id')).to eq(zone_id)
      end

      it 'sets la_name in the session' do
        subject
        expect(session.dig(:vehicle_details, 'la_name')).to eq(zone_name)
      end

      it 'sets daily_charge in the session' do
        subject
        expect(session.dig(:vehicle_details, 'daily_charge')).to eq(charge)
      end

      it 'sets weekly_possible to false' do
        subject
        expect(session[:vehicle_details]['weekly_possible']).to be_falsey
      end

      context 'when vehicle is a taxi in Leeds' do
        before do
          add_to_session(vrn: 'CU57ABC', country: 'UK', leeds_taxi: true)
        end

        it 'returns redirect to DatesController#select_period' do
          expect(subject).to redirect_to(select_period_dates_path)
        end

        it 'sets weekly_possible to true' do
          subject
          expect(session[:vehicle_details]['weekly_possible']).to be_truthy
        end
      end
    end

    context 'without selected zone' do
      let(:zone_id) { nil }

      it 'returns redirect to #local_authority' do
        expect(subject).to redirect_to(local_authority_charges_path)
      end
    end
  end
end
