# frozen_string_literal: true

require 'rails_helper'

describe '.validate_host_headers!', type: :request do
  before do
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
    allow(Rails.application.config.x).to receive(:host).and_return('https://example.com')
    allow(Security::HostHeaderValidator).to receive(:call).and_raise(InvalidHostException)
    get cookies_path
  end

  it 'renders the service unavailable page' do
    expect(response).to render_template(:service_unavailable)
  end

  it 'returns a :forbidden response' do
    expect(response).to have_http_status(:forbidden)
  end
end
