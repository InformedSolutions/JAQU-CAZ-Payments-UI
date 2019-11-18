# frozen_string_literal: true

module SessionManipulation
  class SetTaxi < BaseManipulator
    LEVEL = 2

    def call
      add_fields(taxi: true)
    end
  end
end
