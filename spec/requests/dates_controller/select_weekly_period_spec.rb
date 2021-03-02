# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - GET #select_weekly_period', type: :request do
  subject { get select_weekly_period_dates_path }

  let(:transaction_id) { SecureRandom.uuid }

  context 'with VRN and LA in the session' do
    context 'when Taxidiscountcaz discount is possible' do
      before { add_details_to_session(weekly_possible: true, weekly_charge_today: true) }

      it 'returns an ok response' do
        subject
        expect(response).to have_http_status(:ok)
      end

      describe 'back button url when first week date is set' do
        before { add_to_session({ first_week_start_date: '2020-05-01' }) }

        it 'sets correct return path' do
          subject
          expect(assigns(:return_path)).to eq(review_payment_charges_path)
        end
      end

      describe 'back button url when first week date is not set' do
        before { add_to_session({ first_week_start_date: nil }) }

        it 'sets correct return path' do
          subject
          expect(assigns(:return_path)).to eq(weekly_charge_dates_path)
        end
      end
    end

    context 'when `weekly_charge_today` in session is nil' do
      before do
        add_transaction_id_to_session(transaction_id)
        add_details_to_session(weekly_possible: true, weekly_charge_today: nil)
      end

      it 'redirects to daily charge page' do
        expect(subject).to redirect_to(daily_charge_dates_path(id: transaction_id))
      end
    end

    context 'when Taxidiscountcaz discount is NOT possible' do
      it_behaves_like 'not allowed Taxidiscountcaz discount'
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
