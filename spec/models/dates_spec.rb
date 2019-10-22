# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates, type: :model do
  subject(:dates) { described_class.new.build }

  describe '.build' do
    it 'returns thirteen days' do
      expect(subject.count).to eq(13)
    end
  end
end
