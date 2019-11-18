# frozen_string_literal: true

module SessionManipulation
  class SetPaymentId < BaseManipulator
    LEVEL = 6

    def initialize(session:, payment_id:)
      @session = session
      @payment_id = payment_id
    end

    def call
      add_fields(payment_id: payment_id)
    end

    private

    attr_reader :payment_id
  end
end
