# frozen_string_literal: true

RSpec.shared_examples 'la is missing' do
  it 'redirects to :local_authority' do
    expect(subject).to redirect_to(local_authority_charges_path(id: transaction_id))
  end
end
