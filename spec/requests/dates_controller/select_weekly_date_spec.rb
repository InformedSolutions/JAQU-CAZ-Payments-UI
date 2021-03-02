# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - GET #select_weekly_date', type: :request do
  subject { get select_weekly_date_dates_path, headers: { HTTP_REFERER: referer } }

  let(:transaction_id) { SecureRandom.uuid }
  let(:referer) { '' }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    let(:paid_dates) { [] }

    before do
      add_details_to_session(weekly_possible: true)
      allow(PaymentsApi).to receive(:paid_payments_dates).and_return(paid_dates)
      stubbed_caz = instance_double(
        'Caz',
        active_charge_start_date: 7.days.ago.strftime(Dates::Weekly::VALUE_DATE_FORMAT)
      )
      allow(FetchSingleCazData).to receive(:call).and_return(stubbed_caz)
    end

    context 'with selected dates on the first week page' do
      before do
        add_to_session(first_week_start_date: '2020-05-01', first_week_back_button: '2020-05-01')
        subject
      end

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

      context 'user chooses date after clicking Change link on Review Payment page if today cannot be paid' do
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
        it 'assigns @input_date' do
          subject
          expect(assigns(:input_date)).to be_nil
        end
      end
    end

    context 'without selected dates on the first week page' do
      before do
        add_to_session(first_week_back_button: '2020-05-01')
        subject
      end

      it 'assigns @input_date' do
        expect(assigns(:input_date)).to eq(Date.parse('2020-05-01'))
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
