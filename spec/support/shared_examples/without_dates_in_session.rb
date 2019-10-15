# frozen_string_literal: true

RSpec.shared_examples 'dates is missing' do
  it 'redirects to :dates' do
    expect(http_request).to redirect_to(dates_charges_path)
  end
end
