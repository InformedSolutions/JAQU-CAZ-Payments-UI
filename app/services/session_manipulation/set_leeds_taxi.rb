# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark vehicle as a taxi of PHV registered in Leeds.
  #
  # ==== Usage
  #    SessionManipulation::SetLeedsTaxi.call(session: session)
  #
  class SetLeedsTaxi < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 3

    # Sets +leeds_taxi+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(leeds_taxi: true)
    end
  end
end
