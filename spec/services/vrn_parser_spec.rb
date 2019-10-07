# frozen_string_literal: true

require 'rails_helper'

describe VrnParser do
  subject(:service) { described_class.call(vrn: vrn) }

  context 'AAA999' do
    let(:vrn) { 'AAA999' }

    it 'returns AAA999' do
      expect(service).to eq('AAA999')
    end
  end

  context 'A999AAA' do
    let(:vrn) { 'A999AAA' }

    it 'returns A999AAA' do
      expect(service).to eq('A999AAA')
    end
  end

  context 'AAA999A' do
    let(:vrn) { 'AAA999A' }

    it 'returns AAA999A' do
      expect(service).to eq('AAA999A')
    end
  end

  context 'AAA9999' do
    let(:vrn) { 'AAA9999' }

    it 'returns AAA9999' do
      expect(service).to eq('AAA9999')
    end
  end

  context 'AA99AAA' do
    let(:vrn) { 'AA99AAA' }

    it 'returns AA99AAA' do
      expect(service).to eq('AA99AAA')
    end
  end

  context '9999AAA' do
    let(:vrn) { '9999AAA' }

    it 'returns 9999AAA' do
      expect(service).to eq('9999AAA')
    end
  end

  context 'A9' do
    let(:vrn) { 'A9' }

    it 'returns --A--9' do
      expect(service).to eq('--A--9')
    end
  end

  context '9A' do
    let(:vrn) { '9A' }

    it 'returns 0009--A' do
      expect(service).to eq('0009--A')
    end
  end

  context 'AA9' do
    let(:vrn) { 'AA9' }

    it 'returns -AA--9' do
      expect(service).to eq('-AA--9')
    end
  end

  context 'A99' do
    let(:vrn) { 'A99' }

    it 'returns --A-99' do
      expect(service).to eq('--A-99')
    end
  end

  context '9AA' do
    let(:vrn) { '9AA' }

    it 'returns 0009-AA' do
      expect(service).to eq('0009-AA')
    end
  end

  context '99A' do
    let(:vrn) { '99A' }

    it 'returns 0099--A' do
      expect(service).to eq('0099--A')
    end
  end

  context 'AAA9' do
    let(:vrn) { 'AAA9' }

    it 'returns AAA--9' do
      expect(service).to eq('AAA--9')
    end
  end

  context 'A999' do
    let(:vrn) { 'A999' }

    it 'returns --A999' do
      expect(service).to eq('--A999')
    end
  end

  context 'AA99' do
    let(:vrn) { 'AA99' }

    it 'returns -AA-99' do
      expect(service).to eq('-AA-99')
    end
  end

  context '9AAA' do
    let(:vrn) { '9AAA' }

    it 'returns 0009AAA' do
      expect(service).to eq('0009AAA')
    end
  end

  context '99AA' do
    let(:vrn) { '99AA' }

    it 'returns 0099-AA' do
      expect(service).to eq('0099-AA')
    end
  end

  context '999A' do
    let(:vrn) { '999A' }

    it 'returns 0999--A' do
      expect(service).to eq('0999--A')
    end
  end

  context 'A9AAA' do
    let(:vrn) { 'A9AAA' }

    it 'returns A--9AAA' do
      expect(service).to eq('A--9AAA')
    end
  end

  context 'AAA9A' do
    let(:vrn) { 'AAA9A' }

    it 'returns AAA--9A' do
      expect(service).to eq('AAA--9A')
    end
  end

  context 'AAA99' do
    let(:vrn) { 'AAA99' }

    it 'returns AAA-99' do
      expect(service).to eq('AAA-99')
    end
  end

  context 'AA999' do
    let(:vrn) { 'AA999' }

    it 'returns -AA999' do
      expect(service).to eq('-AA999')
    end
  end

  context '99AAA' do
    let(:vrn) { '99AAA' }

    it 'returns 0099AAA' do
      expect(service).to eq('0099AAA')
    end
  end

  context '999AA' do
    let(:vrn) { '999AA' }

    it 'returns 0999-AA' do
      expect(service).to eq('0999-AA')
    end
  end

  context '9999A' do
    let(:vrn) { '9999A' }

    it 'returns 9999--A' do
      expect(service).to eq('9999--A')
    end
  end

  context 'A9999' do
    let(:vrn) { 'A9999' }

    it 'returns --A9999' do
      expect(service).to eq('--A9999')
    end
  end

  context 'A99AAA' do
    let(:vrn) { 'A99AAA' }

    it 'returns A-99AAA' do
      expect(service).to eq('A-99AAA')
    end
  end

  context 'AAA99A' do
    let(:vrn) { 'AAA99A' }

    it 'returns AAA-99A' do
      expect(service).to eq('AAA-99A')
    end
  end

  context '999AAA' do
    let(:vrn) { '999AAA' }

    it 'returns 0999AAA' do
      expect(service).to eq('0999AAA')
    end
  end

  context 'AA9999' do
    let(:vrn) { 'AA9999' }

    it 'returns -AA9999' do
      expect(service).to eq('-AA9999')
    end
  end

  context '9999AA' do
    let(:vrn) { '9999AA' }

    it 'returns 9999-AA' do
      expect(service).to eq('9999-AA')
    end
  end
end
