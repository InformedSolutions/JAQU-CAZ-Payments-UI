# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Dates, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  subject(:dates) { described_class.new.build }

  describe '.build' do
    context 'today is monday' do
      it 'returns twelve days' do
        travel_to(Date.parse('2019-10-07')) do
          expect(subject.count).to eq(13)
        end
      end
    end

    context 'today is tuesday' do
      it 'returns ten days' do
        travel_to(Date.parse('2019-10-08')) do
          expect(subject.count).to eq(13)
        end
      end
    end

    context 'today is wednesday' do
      it 'returns ten days' do
        travel_to(Date.parse('2019-10-09')) do
          expect(subject.count).to eq(13)
        end
      end
    end

    context 'today is thursday ' do
      it 'returns ten days' do
        travel_to(Date.parse('2019-10-10')) do
          expect(subject.count).to eq(13)
        end
      end
    end

    context 'today is friday' do
      it 'returns ten days' do
        travel_to(Date.parse('2019-10-10')) do
          expect(subject.count).to eq(13)
        end
      end
    end

    context 'today is saturday' do
      it 'returns eleven days' do
        travel_to(Date.parse('2019-10-12')) do
          expect(subject.count).to eq(13)
        end
      end
    end

    context 'today is sunday' do
      it 'returns eleven days' do
        travel_to(Date.parse('2019-10-13')) do
          expect(subject.count).to eq(13)
        end
      end
    end
  end
end
