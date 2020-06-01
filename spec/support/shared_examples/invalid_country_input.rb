# frozen_string_literal: true

RSpec.shared_examples 'an invalid country input' do
  it { is_expected.not_to be_valid }

  it 'has a proper error message' do
    expect(form.errors.messages[:country])
      .to include(I18n.t('vrn_form.country_missing'))
  end
end
