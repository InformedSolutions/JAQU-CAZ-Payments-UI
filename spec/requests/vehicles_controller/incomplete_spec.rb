# frozen_string_literal: true

require 'rails_helper'

describe 'VehiclesController - GET #incomplete', type: :request do
  subject { get incomplete_vehicles_path }

  before do
    add_vrn_to_session(vrn: 'CU57ABC')
    subject
  end

  it 'returns a success response' do
    expect(response).to have_http_status(:success)
  end

  it 'renders the view' do
    expect(response).to render_template(:incomplete)
  end
end
