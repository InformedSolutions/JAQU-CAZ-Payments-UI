# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark vehicle as undetermined in the DVLA database.
  #
  # ==== Usage
  #    SessionManipulation::SetUndetermined.call(session: session)
  #
  class SetUndetermined < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 3

    # Sets +undetermined+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(undetermined: true)
    end
  end
end
