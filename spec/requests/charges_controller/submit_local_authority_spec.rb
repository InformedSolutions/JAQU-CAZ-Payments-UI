# frozen_string_literal: true

require 'rails_helper'

describe 'ChargesController - POST #submit_local_authority', type: :request do
  subject do
    post submit_local_authority_charges_path, params: { 'local-authority': zone_id }
  end

  let(:transaction_id) { SecureRandom.uuid }
  let(:zone_id) { SecureRandom.uuid }
  let(:zone_name) { 'Taxidiscountcaz' }
  let(:charge) { 50 }
  let(:tariff) { 'BCC01-private_car' }
  let(:phgv_discount_available) { true }

  context 'with VRN set' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session
      details = instance_double(ComplianceDetails,
                                zone_name: zone_name,
                                charge: charge,
                                tariff_code: tariff,
                                phgv_discount_available?: phgv_discount_available)
      unrecognised_details = instance_double(UnrecognisedComplianceDetails,
                                             zone_name: zone_name,
                                             charge: charge,
                                             tariff_code: tariff)

      allow(ComplianceDetails).to receive(:new).and_return(details)
      allow(UnrecognisedComplianceDetails).to receive(:new).and_return(unrecognised_details)
    end

    context 'with undetermined_taxi in session' do
      before { add_undetermined_taxi_to_session }

      it 'returns redirect to #daily_charge' do
        expect(subject).to redirect_to(daily_charge_dates_path(id: transaction_id))
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

      it 'sets tariff_code in the session' do
        subject
        expect(session.dig(:vehicle_details, 'tariff_code')).to eq(tariff)
      end

      it 'calls UnrecognisedComplianceDetails to fetch compliance data' do
        subject
        expect(UnrecognisedComplianceDetails).to have_received(:new).with(la_id: zone_id)
      end
    end

    context 'with selected zone' do
      it 'returns redirect to #daily_charge' do
        expect(subject).to redirect_to(daily_charge_dates_path(id: transaction_id))
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

      context 'when vehicle is a taxi in Taxidiscountcaz' do
        before do
          add_vehicle_details_to_session(vrn: 'CU57ABC', country: 'UK', weekly_taxi: true)
        end

        it 'returns redirect to DatesController#select_period' do
          expect(subject).to redirect_to(select_period_dates_path(id: transaction_id))
        end

        it 'sets weekly_possible to true' do
          subject
          expect(session[:vehicle_details]['weekly_possible']).to be_truthy
        end
      end

      context 'when vehicle has phgv_discount_available true in Bath' do
        let(:zone_name) { 'Bath' }

        it 'returns redirect to ChargesController#discount_available' do
          expect(subject).to redirect_to(discount_available_charges_path(id: transaction_id))
        end
      end

      context 'when vehicle has phgv_discount_available false in Bath' do
        let(:phgv_discount_available) { false }

        it 'returns redirect to ChargesController#discount_available' do
          expect(subject).to redirect_to(daily_charge_dates_path(id: transaction_id))
        end
      end

      context 'when vehicle has phgv_discount_available true but zone Birmingham' do
        let(:zone_name) { 'Birmingham' }

        it 'returns redirect to ChargesController#discount_available' do
          expect(subject).to redirect_to(daily_charge_dates_path(id: transaction_id))
        end
      end

      context 'when vehicle has phgv_discount_available false and zone Birmingham' do
        let(:zone_name) { 'Birmingham' }
        let(:phgv_discount_available) { false }

        it 'returns redirect to ChargesController#discount_available' do
          expect(subject).to redirect_to(daily_charge_dates_path(id: transaction_id))
        end
      end
    end

    context 'without selected zone' do
      let(:zone_id) { nil }

      it 'returns redirect to #local_authority' do
        expect(subject).to redirect_to(local_authority_charges_path(id: transaction_id))
      end
    end
  end
end
