# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RefundsController, type: :request do
  describe 'GET #scenarios' do
    subject { get scenarios_refunds_path }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #details' do
    subject { get details_refunds_path }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
