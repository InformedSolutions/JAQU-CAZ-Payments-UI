# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - POST #confirm_date_weekly', type: :request do
  subject do
    post confirm_date_weekly_dates_path, params: params
  end

  let(:charge) { 12.5 }
  let(:session_details) do
    {
      daily_charge: charge,
      vrn: vrn,
      la_id: la_id
    }
  end
  let(:vrn) { 'CU123AB' }
  let(:la_id) { SecureRandom.uuid }
  let(:params) { { 'date_year' => '2019', 'date_month' => '11', 'date_day' => '01' } }

  before do
    details = instance_double(Dates::ValidateSelectedWeeklyDate,
                              start_date: '2019-11-1',
                              parse_date: '2019-11-1',
                              date_in_range?: true,
                              error: '',
                              valid?: true)
    allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)
  end

  context 'with details in the session' do
    before do
      add_details_to_session(details: session_details, weekly_possible: true)
      allow(Dates::CheckPaidWeekly).to receive(:call).and_return(true)
    end

    it 'redirects to :review_payment' do
      subject
      expect(subject).to redirect_to(review_payment_charges_path)
    end

    it 'calls Dates::CheckPaidWeekly with right params' do
      expect(Dates::CheckPaidWeekly).to receive(:call).with(
        vrn: vrn, zone_id: la_id, date: '2019-11-1'
      )
      subject
    end

    describe 'setting session' do
      before { subject }

      it 'sets total_charge to Leeds discounted value of 50' do
        expect(session[:vehicle_details]['total_charge']).to eq(50)
      end

      it 'sets dates to next 7 day starting from selected date' do
        expected_dates = (1..7).map { |day| "2019-11-0#{day}" }
        expect(session[:vehicle_details]['dates']).to eq(expected_dates)
      end

      it 'sets weekly to true' do
        expect(session[:vehicle_details]['weekly']).to be_truthy
      end
    end

    context 'without checked dates' do
      before do
        details = instance_double(Dates::ValidateSelectedWeeklyDate,
                                  start_date: false,
                                  parse_date: false,
                                  date_in_range?: false,
                                  error: I18n.t('dates.weekly.empty'),
                                  valid?: false)
        allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)
      end

      it 'redirects to :dates_charges' do
        expect(subject).to redirect_to(select_weekly_date_dates_path)
      end

      it 'sets proper alert' do
        subject
        expect(flash[:alert]).to eq(I18n.t('dates.weekly.empty'))
      end

      it 'does not call Dates::CheckPaidWeekly' do
        expect(Dates::CheckPaidWeekly).not_to receive(:call)
        subject
      end
    end

    context 'when dates are already paid' do
      before do
        details = instance_double(Dates::ValidateSelectedWeeklyDate,
                                  start_date: '2019-11-1',
                                  parse_date: '2019-11-1',
                                  date_in_range?: true,
                                  error: I18n.t('dates.weekly.paid'),
                                  valid?: true)
        allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)

        allow(Dates::CheckPaidWeekly).to receive(:call).and_return(false)
        subject
      end

      it 'redirects to :dates_charges' do
        expect(response).to redirect_to(select_weekly_date_dates_path)
      end

      it 'sets proper alert' do
        expect(flash[:alert]).to eq(I18n.t('dates.weekly.paid'))
      end

      it 'does not set total_charge' do
        expect(session[:vehicle_details]['total_charge']).to be_nil
      end

      it 'does not set dates' do
        expect(session[:vehicle_details]['dates']).to be_nil
      end

      it 'does not set weekly' do
        expect(session[:vehicle_details]['weekly']).to be_nil
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
