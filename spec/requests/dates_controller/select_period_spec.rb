# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DatesController - GET #select_period', type: :request do
  subject { get select_period_dates_path }

  context 'with VRN and LA in the session' do
    context 'when Leeds weekly discount is possible' do
      before { add_details_to_session(weekly_possible: true) }

      it 'returns a success response' do
        subject
        expect(response).to have_http_status(:success)
      end

      describe 'default back button url' do
        subject { get select_period_dates_path }

        it 'assigns correct return path' do
          subject
          expect(assigns(:return_path)).to eq(local_authority_charges_path)
        end
      end

      describe 'back button url when second_week parameter is false' do
        subject { get select_period_dates_path(second_week: false) }

        it 'assigns correct return path' do
          subject
          expect(assigns(:return_path)).to eq(select_weekly_date_dates_path)
        end
      end

      describe 'back button url when second_week parameter is true' do
        subject { get select_period_dates_path(second_week: true) }

        it 'assigns correct return path' do
          subject
          expect(assigns(:return_path)).to eq(select_second_weekly_date_dates_path)
        end
      end
    end

    context 'when Leeds weekly discount is NOT possible' do
      it_behaves_like 'not allowed Leeds discount'
    end
  end

  context 'without VRN in the session' do
    it_behaves_like 'vrn is missing'
  end

  context 'without LA in the session' do
    before do
      add_vrn_to_session
    end

    it_behaves_like 'la is missing'
  end
end
