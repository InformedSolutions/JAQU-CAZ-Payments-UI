# frozen_string_literal: true

RSpec.shared_examples 'vrn is missing' do
  it 'redirects to :enter_details' do
    expect(subject).to redirect_to(enter_details_vehicles_path)
  end
end
