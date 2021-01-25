# frozen_string_literal: true

require 'rails_helper'

describe ConfirmationForm, type: :model do
  subject(:form) { described_class.new(confirmation) }

  let(:confirmation) { 'yes' }

  it { is_expected.to be_valid }

  describe '.confirmed?' do
    context 'when confirmation equals yes' do
      it 'returns true' do
        expect(form.confirmed?).to eq(true)
      end
    end

    context 'when confirmation equals no' do
      let(:confirmation) { 'no' }

      it 'returns false' do
        expect(form.confirmed?).to eq(false)
      end
    end
  end

  context 'when confirmation is empty' do
    let(:confirmation) { '' }

    before do
      form.valid?
    end

    it { is_expected.not_to be_valid }

    it 'has a proper error message' do
      expect(form.errors.messages[:confirmation]).to include(
        'Select yes if the details are correct'
      )
    end
  end
end
