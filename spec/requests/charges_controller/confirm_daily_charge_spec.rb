# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ChargesController - POST #confirm_daily_charge', type: :request do
  subject(:http_request) do
    post confirm_daily_charge_charges_path, params: { 'confirm-exempt' => confirmation }
  end

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:confirmation) { 'yes' }

  context 'with VRN an LA in the session' do
    before do
      add_vrn_to_session(vrn: vrn)
      add_la_to_session(zone_id)
    end

    context 'with checked checkbox' do
      it 'redirects to :dates' do
        expect(http_request).to redirect_to(dates_charges_path)
      end
    end

    context 'without checked checkbox' do
      let(:confirmation) { nil }

      it 'redirects to :daily_charge' do
        expect(http_request).to redirect_to(daily_charge_charges_path)
      end
    end
  end
end
