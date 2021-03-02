# frozen_string_literal: true

require 'rails_helper'

describe 'DatesController - POST #confirm_second_date_weekly', type: :request do
  subject do
    post confirm_second_date_weekly_dates_path, params: params
  end

  let(:transaction_id) { SecureRandom.uuid }
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
                              valid?: true,
                              add_dates_to_session: true)
    allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)
    stubbed_caz = instance_double(
      'Caz',
      active_charge_start_date: 7.days.ago.strftime(Dates::Weekly::VALUE_DATE_FORMAT)
    )
    allow(FetchSingleCazData).to receive(:call).and_return(stubbed_caz)
  end

  context 'with details in the session' do
    before do
      add_transaction_id_to_session(transaction_id)
      add_details_to_session(details: session_details, weekly_possible: true)
      allow(Dates::CheckPaidWeekly).to receive(:call).and_return(true)
    end

    it 'redirects to :review_payment' do
      subject
      expect(subject).to redirect_to(review_payment_charges_path(id: transaction_id))
    end

    it 'calls Dates::CheckPaidWeekly with right params' do
      subject
      expect(Dates::CheckPaidWeekly).to have_received(:call).with(vrn: vrn, zone_id: la_id, date: '2019-11-1')
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
        expect(subject).to redirect_to(select_second_weekly_date_dates_path(id: transaction_id))
      end

      it 'sets proper alert' do
        subject
        expect(flash[:alert]).to eq(I18n.t('dates.weekly.empty'))
      end

      it 'does not call Dates::CheckPaidWeekly' do
        subject
        expect(Dates::CheckPaidWeekly).not_to have_received(:call)
      end
    end

    context 'without checked dates when second week is being selected' do
      before do
        assign_second_week_selected
        details = instance_double(Dates::ValidateSelectedWeeklyDate,
                                  start_date: false,
                                  parse_date: false,
                                  date_in_range?: false,
                                  error: I18n.t('dates.weekly.empty'),
                                  valid?: false)
        allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)
      end

      it 'redirects to :dates_charges' do
        expect(subject).to redirect_to(select_second_weekly_date_dates_path(id: transaction_id))
      end

      it 'sets proper alert' do
        subject
        expect(flash[:alert]).to eq(I18n.t('dates.weekly.empty'))
      end
    end

    context 'when dates are already paid' do
      before do
        details = instance_double(Dates::ValidateSelectedWeeklyDate,
                                  start_date: '2019-11-1',
                                  parse_date: '2019-11-1',
                                  date_in_range?: true,
                                  error: I18n.t('dates.weekly.not_available'),
                                  valid?: true)
        allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)

        allow(Dates::CheckPaidWeekly).to receive(:call).and_return(false)
        subject
      end

      it 'redirects to :dates_charges' do
        expect(response).to redirect_to(select_second_weekly_date_dates_path(id: transaction_id))
      end

      it 'sets proper alert' do
        expect(flash[:alert]).to eq(I18n.t('dates.weekly.not_available'))
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

    context 'when the date was already selected in the first week' do
      before do
        assign_second_week_selected
        details = instance_double(Dates::ValidateSelectedWeeklyDate,
                                  start_date: '2019-11-5',
                                  parse_date: '2019-11-5',
                                  date_in_range?: true,
                                  error: I18n.t('dates.weekly.already_selected'),
                                  valid?: false)
        allow(Dates::ValidateSelectedWeeklyDate).to receive(:new).and_return(details)
        allow(Dates::CheckPaidWeekly).to receive(:call).and_return(false)
        add_full_payment_details(weekly: true)
        subject
      end

      it 'redirects to :select_weekly_date' do
        expect(response).to redirect_to(select_second_weekly_date_dates_path(id: transaction_id))
      end

      it 'sets proper alert' do
        expect(flash[:alert]).to eq(I18n.t('dates.weekly.already_selected'))
      end

      it 'does not change total_charge' do
        expect(session[:vehicle_details]['total_charge']).to eq(50)
      end

      it 'does not change dates' do
        expect(session[:vehicle_details]['dates']).to eq(payment_dates({}, true))
      end

      it 'does not change weekly' do
        expect(session[:vehicle_details]['weekly']).to eq(true)
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

  context 'when Taxidiscountcaz weekly discount is NOT possible' do
    it_behaves_like 'not allowed Taxidiscountcaz discount'
  end
end
