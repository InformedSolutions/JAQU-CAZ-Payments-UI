# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :request do
  describe 'GET #index' do
    subject { get welcome_index_path }

    it 'returns http success' do
      subject
      expect(response).to have_http_status(:success)
    end
  end
end
