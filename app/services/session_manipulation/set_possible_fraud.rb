# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark vehicle as possible fraud.
  #
  # ==== Usage
  #    SessionManipulation::SetPossibleFraud.call(session: session)
  #
  class SetPossibleFraud < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 2

    # Sets +possible_fraud+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(possible_fraud: true)
    end
  end
end
