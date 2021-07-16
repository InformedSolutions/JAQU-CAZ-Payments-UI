# frozen_string_literal: true

RSpec.shared_examples 'a static page' do |template|
  before { subject }

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end

  it 'renders the view' do
    expect(response).to render_template(template)
  end
end
