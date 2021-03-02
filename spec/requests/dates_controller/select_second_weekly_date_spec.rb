# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - GET #select_second_weekly_date', type: :request do
  subject { get select_second_weekly_date_dates_path }

  let(:transaction_id) { SecureRandom.uuid }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    before do
      assign_second_week_selected
      add_details_to_session(weekly_possible: true)
      allow(PaymentsApi).to receive(:paid_payments_dates).and_return(paid_dates)
      stubbed_caz = instance_double(
        'Caz',
        active_charge_start_date: 7.days.ago.strftime(Dates::Weekly::VALUE_DATE_FORMAT)
      )
      allow(FetchSingleCazData).to receive(:call).and_return(stubbed_caz)
      subject
    end

    let(:paid_dates) { [] }

    context 'a week starting from today can be paid' do
      before { subject }

      it 'returns an ok response' do
        expect(response).to have_http_status(:ok)
      end

      it 'calls FetchSingleCazData service' do
        expect(FetchSingleCazData).to have_received(:call)
      end

      it 'assigns the @d_day_notice variable' do
        expect(assigns(:d_day_notice)).to eq(false)
      end
    end

    context "a week starting from today can't be paid" do
      let(:paid_dates) { [Date.current.strftime(Dates::Weekly::VALUE_DATE_FORMAT)] }

      before { subject }

      it 'returns a success response' do
        expect(response).to have_http_status(:success)
      end

      it 'calls FetchSingleCazData service' do
        expect(FetchSingleCazData).to have_received(:call)
      end

      it 'assigns the @d_day_notice variable' do
        expect(assigns(:d_day_notice)).to eq(false)
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without details in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end

  context 'when Taxidiscountcaz discount is NOT possible' do
    it_behaves_like 'not allowed Taxidiscountcaz discount'
  end
end
