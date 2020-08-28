# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark vehicle as unrecognised in the DVLA database.
  #
  # ==== Usage
  #    SessionManipulation::SetUnrecognised.call(session: session)
  #
  class SetUnrecognised < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 4

    # Sets +unrecognised+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(unrecognised: true)
    end
  end
end
