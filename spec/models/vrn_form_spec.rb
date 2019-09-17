# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VrnForm, type: :model do
  subject(:form) { described_class.new(vrn, country) }

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }

  context 'with proper VRN' do
    it { is_expected.to be_valid }

    it 'has an empty hash as error_object' do
      expect(form.error_object).to eq({})
    end
  end

  describe 'both fields validation' do
    before { form.valid? }

    context 'when country and vrn are nil' do
      let(:country) { nil }
      let(:vrn) { nil }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid country input'
      it_behaves_like 'an invalid vrn input', I18n.t('vrn_form.vrn_missing')
    end
  end

  context 'country validation' do
    before { form.valid? }

    context 'when country is nil' do
      let(:country) { nil }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid country input'
    end

    context 'when country is empty' do
      let(:country) { '' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid country input'
    end
  end

  context 'VRN validation' do
    before { form.valid? }

    context 'when VRN is empty' do
      let(:vrn) { '' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid vrn input', I18n.t('vrn_form.vrn_missing')
    end

    context 'when VRN is too long' do
      let(:vrn) { 'ABCDEFGH' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid vrn input', I18n.t('vrn_form.vrn_too_long')
    end

    context 'when VRN is too short' do
      let(:vrn) { 'A' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid vrn input', I18n.t('vrn_form.vrn_too_short')
    end

    context 'when VRN has special signs' do
      let(:vrn) { 'ABCDE$%' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid vrn input', I18n.t('vrn_form.vrn_invalid')
    end

    context 'when VRN has too many numbers' do
      let(:vrn) { 'C111999' }

      it { is_expected.not_to be_valid }

      it_behaves_like 'an invalid vrn input', I18n.t('vrn_form.vrn_invalid')
    end

    context 'when country in Non-UK' do
      let(:country) { 'Non-UK' }

      context 'when VRN is empty' do
        let(:vrn) { '' }

        it { is_expected.not_to be_valid }

        it_behaves_like 'an invalid vrn input', I18n.t('vrn_form.vrn_missing')
      end

      context 'when VRN is too long' do
        let(:vrn) { 'ABCDEFGH' }

        it { is_expected.to be_valid }
      end

      context 'when VRN is too short' do
        let(:vrn) { 'A' }

        it { is_expected.to be_valid }
      end

      context 'when VRN has special signs' do
        let(:vrn) { 'ABCDE$%' }

        it { is_expected.to be_valid }
      end

      context 'when VRN has too many numbers' do
        let(:vrn) { 'C111999' }

        it { is_expected.to be_valid }
      end
    end
  end

  describe 'VRN formats' do
    describe 'invalid formats' do
      context 'when VRN is in format AA' do
        let(:vrn) { 'AB' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format 99' do
        let(:vrn) { '45' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format AAA' do
        let(:vrn) { 'ABG' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format 999' do
        let(:vrn) { '452' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format AAAA' do
        let(:vrn) { 'TABG' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format 9999' do
        let(:vrn) { '4521' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format AAAAA' do
        let(:vrn) { 'TAFBG' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format 99999' do
        let(:vrn) { '45921' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format AAAAAA' do
        let(:vrn) { 'AHTDSE' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format A999A9' do
        let(:vrn) { 'A123B5' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format 9999999' do
        let(:vrn) { '4111929' }

        it { is_expected.not_to be_valid }
      end

      context 'when VRN is in format A9999A9' do
        let(:vrn) { 'C1119C9' }

        it { is_expected.not_to be_valid }
      end
    end

    context 'with spaces' do
      context 'when VRN is in format AAA 999' do
        let(:vrn) { 'ABC 123' }

        it { is_expected.to be_valid }
      end
    end

    context 'when VRN is in format AAA999' do
      let(:vrn) { 'ABC123' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format A999AAA' do
      let(:vrn) { 'A123BCD' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AAA999A' do
      let(:vrn) { 'GAD975C' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AAA9999' do
      let(:vrn) { 'ZEA1436' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AA99AAA' do
      let(:vrn) { 'SK12JKL' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 9999AAA' do
      let(:vrn) { '7429HER' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format A9' do
      let(:vrn) { 'G5' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 9A' do
      let(:vrn) { '6W' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AA9' do
      let(:vrn) { 'JK4' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format A99' do
      let(:vrn) { 'P91' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 9AA' do
      let(:vrn) { '9RA' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 99A' do
      let(:vrn) { '81U' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AAA9' do
      let(:vrn) { 'KAT7' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format A999' do
      let(:vrn) { 'Y478' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AA99' do
      let(:vrn) { 'LK31' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 9AAA' do
      let(:vrn) { '8RAD' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 99AA' do
      let(:vrn) { '87KJ' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 999A' do
      let(:vrn) { '111Z' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format A9AAA' do
      let(:vrn) { 'A7CUD' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AAA9A' do
      let(:vrn) { 'VAR7A' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AAA99' do
      let(:vrn) { 'FES23' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AA999' do
      let(:vrn) { 'PG227' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 99AAA' do
      let(:vrn) { '30JFA' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 999AA' do
      let(:vrn) { '868BO' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 9999A' do
      let(:vrn) { '1289J' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format A9999' do
      let(:vrn) { 'B8659' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format A99AAA' do
      let(:vrn) { 'K97LUK' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AAA99A' do
      let(:vrn) { 'MAN07U' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 999AAA' do
      let(:vrn) { '546BAR' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format AA9999' do
      let(:vrn) { 'JU0043' }

      it { is_expected.to be_valid }
    end

    context 'when VRN is in format 9999AA' do
      let(:vrn) { '8839GF' }

      it { is_expected.to be_valid }
    end
  end
end
