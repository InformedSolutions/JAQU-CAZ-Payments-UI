# frozen_string_literal: true

module SessionManipulation
  class SetUnrecognised < BaseManipulator
    LEVEL = 2

    def call
      add_fields(unrecognised: true)
    end
  end
end
