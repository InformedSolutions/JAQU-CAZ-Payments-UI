# frozen_string_literal: true

RSpec.shared_examples 'charge is missing' do
  it 'redirects to :enter_details_vehicles' do
    expect(http_request).to redirect_to(enter_details_vehicles_path)
  end
end
