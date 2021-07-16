# frozen_string_literal: true

require 'rails_helper'

describe StaticPagesController, type: :request do
  describe 'GET #accessibility_statement' do
    subject { get accessibility_statement_path }

    it_behaves_like 'a static page', :accessibility_statement
  end

  describe 'GET #cookies' do
    subject { get cookies_path }

    it_behaves_like 'a static page', :cookies
  end

  describe 'GET #privacy_notice' do
    subject { get privacy_notice_path }

    before { mock_chargeable_zones }

    it_behaves_like 'a static page', :privacy_notice
  end

  describe 'GET #terms_and_conditions' do
    subject { get terms_and_conditions_path }

    it_behaves_like 'a static page', :terms_and_conditions
  end

  context 'when service call returns `InvalidHostException`' do
    subject { get privacy_notice_path }

    before do
      allow(CazDataProvider).to receive(:new).and_raise(InvalidHostException)
      subject
    end

    it 'renders the service unavailable page' do
      expect(response).to render_template(:service_unavailable)
    end

    it 'returns a :forbidden response' do
      expect(response).to have_http_status(:forbidden)
    end
  end
end
