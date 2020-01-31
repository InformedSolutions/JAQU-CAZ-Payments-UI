# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CookiesController do
  describe 'GET #index' do
    subject(:http_request) { get cookies_path }

    it 'returns http success' do
      http_request
      expect(response).to have_http_status(:success)
    end
  end
end
