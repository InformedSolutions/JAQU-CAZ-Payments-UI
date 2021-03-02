# frozen_string_literal: true

RSpec.shared_examples 'not allowed Taxidiscountcaz discount' do
  before do
    add_transaction_id_to_session(transaction_id)
    add_details_to_session(weekly_possible: false)
    subject
  end

  it 'redirects to the normal path' do
    expect(response).to redirect_to(daily_charge_dates_path(id: transaction_id))
  end
end
