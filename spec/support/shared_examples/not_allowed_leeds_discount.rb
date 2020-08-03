# frozen_string_literal: true

RSpec.shared_examples 'not allowed Leeds discount' do
  before do
    add_details_to_session(weekly_possible: false)
    subject
  end

  it 'redirects to the normal path' do
    expect(response).to redirect_to(daily_charge_dates_path)
  end
end
