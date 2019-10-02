# frozen_string_literal: true

RSpec.shared_examples 'an invalid vrn input' do |error_message|
  it { is_expected.not_to be_valid }

  it 'has a proper error message' do
    expect(form.errors.messages[:vrn]).to include(error_message)
  end
end
