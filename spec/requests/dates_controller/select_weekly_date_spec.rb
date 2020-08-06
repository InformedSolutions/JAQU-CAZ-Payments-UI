# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_weekly_date', type: :request do
  subject { get select_weekly_date_dates_path, headers: { 'HTTP_REFERER': referer } }

  let(:referer) { '' }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    before do
      add_details_to_session(weekly_possible: true)
      add_weekly_selection_dates(first_week_start_date: '2020-05-01', first_week_back_button: '2020-05-01')
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
      it 'returns a found response' do
        subject
        expect(response).to have_http_status(:found)
      end

      it 'calls FetchSingleCazData service' do
        expect(FetchSingleCazData).to have_received(:call)
      end

      it 'assigns the @d_day_notice variable' do
        expect(assigns(:d_day_notice)).to eq(false)
      end

      it 'assigns the @return_path variable' do
        expect(assigns(:return_path)).to eq(weekly_charge_dates_path)
      end
    end

    context "a week starting from today can't be paid" do
      let(:paid_dates) { [Date.current.strftime(Dates::Weekly::VALUE_DATE_FORMAT)] }

      it 'returns a success response' do
        subject
        expect(response).to have_http_status(:success)
      end

      it 'calls FetchSingleCazData service' do
        expect(FetchSingleCazData).to have_received(:call)
      end

      it 'assigns the @d_day_notice variable' do
        expect(assigns(:d_day_notice)).to eq(false)
      end
    end

    context 'user chooses date after clicking Change button on Review Payment page if today cannot be paid' do
      subject { get select_weekly_date_dates_path(change: true) }

      it 'returns a found response' do
        subject
        expect(response).to have_http_status(:found)
      end

      it 'calls FetchSingleCazData service' do
        expect(FetchSingleCazData).to have_received(:call)
      end

      it 'assigns the @d_day_notice variable' do
        expect(assigns(:d_day_notice)).to eq(false)
      end

      it 'assigns the @return_path variable' do
        expect(assigns(:return_path)).to eq(review_payment_charges_path)
      end
    end

    context 'user chooses date after clicking Back button on Review Payment page' do
      let(:referer) { 'http://www.example.com/charges/review_payment' }

      it 'assigns @input_date' do
        subject
        expect(assigns(:input_date)).to eq(Date.parse('2020-05-01'))
      end
    end

    context 'user chooses date after coming back to the page not from Review Payment' do
      let(:referer) { '' }

      it 'assigns @input_date' do
        subject
        expect(assigns(:input_date)).to eq(Date.parse('2020-05-01'))
      end
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without details in the session' do
    before { add_vrn_to_session }

    it_behaves_like 'la is missing'
  end

  context 'when Leeds weekly discount is NOT possible' do
    it_behaves_like 'not allowed Leeds discount'
  end
end
