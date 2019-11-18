# frozen_string_literal: true

module SessionManipulation
  class SetIncorrect < BaseManipulator
    LEVEL = 3

    def call
      # Can not be both unrecognised and incorrect
      session[SESSION_KEY] = session[SESSION_KEY].except('unrecognised')
      add_fields(incorrect: true)
    end
  end
end
