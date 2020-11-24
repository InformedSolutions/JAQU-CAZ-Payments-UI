# frozen_string_literal: true

require 'rails_helper'

describe WelcomeController, type: :request do
  describe 'GET #index' do
    subject { get root_path }

    let(:payment_id) { 'XYZ123ABC' }
    let(:vrn) { 'CU57ABC' }

    before do
      add_vehicle_details_to_session(payment_id: payment_id, vrn: vrn)
      subject
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'clears payment details in session' do
      expect(session[:vehicle_details]).to be_empty
    end
  end
end
