# frozen_string_literal: true

RSpec.shared_examples 'dates is missing' do
  it 'redirects to :dates' do
    expect(http_request).to redirect_to(select_daily_date_charges_path)
  end
end
