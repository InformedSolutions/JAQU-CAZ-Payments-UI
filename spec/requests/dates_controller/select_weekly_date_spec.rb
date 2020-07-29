# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_weekly_date', type: :request do
  subject { get select_weekly_date_dates_path }

  context 'with VRN, COUNTRY, LA, LA NAME and CHARGE in the session' do
    before do
      add_details_to_session(weekly_possible: true)
      allow(PaymentsApi).to receive(:paid_payments_dates).and_return(paid_dates)
      stubbed_caz = instance_double('Caz', active_charge_start_date: parse_date(7.days.ago))
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
    end

    context 'a week starting from today can be paid' do
      let(:paid_dates) { [parse_date(Date.current)] }

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

def parse_date(date)
  date.strftime(Dates::Weekly::VALUE_DATE_FORMAT)
end
