# frozen_string_literal: true

RSpec.shared_examples 'an unsuccessful API call' do
  it 'returns 503 error code' do
    http_request
    expect(response).to have_http_status(503)
  end

  it 'renders error page' do
    expect(http_request).to render_template('errors/service_unavailable')
  end
end
