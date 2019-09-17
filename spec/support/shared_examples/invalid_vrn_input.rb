# frozen_string_literal: true

RSpec.shared_examples 'an invalid vrn input' do |error_message|
  it 'has a proper error message' do
    expect(form.error_object[:vrn][:message]).to eq(error_message)
  end

  it 'has a proper link value' do
    expect(form.error_object[:vrn][:link]).to eq('#vrn-error')
  end
end
