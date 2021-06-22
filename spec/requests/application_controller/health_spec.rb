# frozen_string_literal: true

require 'rails_helper'

describe 'ApplicationController - GET #health', type: :request do
  subject { get health_path }

  it 'returns a 200 OK status' do
    subject
    expect(response).to have_http_status(:ok)
  end
end
