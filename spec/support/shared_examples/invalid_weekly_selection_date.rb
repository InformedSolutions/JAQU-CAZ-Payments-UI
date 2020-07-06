# frozen_string_literal: true

RSpec.shared_examples 'an invalid weekly selection date' do
  it 'assigns nil to @start_date' do
    expect(service.start_date).to be_falsey
  end

  it 'returns nil for .date_in_range?' do
    expect(service.date_in_range?).to be_falsey
  end

  it 'returns nil for .date_chargeable?' do
    expect(service.date_chargeable?).to be_falsey
  end

  it 'returns nil for .valid?' do
    expect(service.valid?).to be_falsey
  end

  it 'returns correct error message' do
    expect(service.error).to eq(I18n.t('empty', scope: 'dates.weekly'))
  end
end
