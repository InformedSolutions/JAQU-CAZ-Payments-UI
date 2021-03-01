# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark unrecognised vehicle as a taxi or PHV registered
  #
  # ==== Usage
  #    SessionManipulation::SetTaxi.call(session: session)
  #
  class SetUndeterminedTaxi < BaseManipulator
    # Level used to clearing current vehicle keys in the session
    LEVEL = 3

    # Sets +undetermined_taxi+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(undetermined_taxi: true)
    end
  end
end
