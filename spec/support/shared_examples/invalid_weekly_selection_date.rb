# frozen_string_literal: true

RSpec.shared_examples 'an invalid weekly selection date' do
  it 'assigns nil to @start_date' do
    expect(subject.start_date).to be_falsey
  end

  it 'returns nil for .valid?' do
    expect(subject.valid?).to be_nil
  end

  it 'returns correct error message' do
    expect(subject.error).to eq(I18n.t('empty', scope: 'dates.weekly'))
  end
end
