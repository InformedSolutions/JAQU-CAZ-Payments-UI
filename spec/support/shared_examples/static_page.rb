# frozen_string_literal: true

RSpec.shared_examples 'a static page' do
  it 'returns a success response' do
    subject
    expect(response).to have_http_status(:success)
  end
end
