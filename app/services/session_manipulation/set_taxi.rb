# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark vehicle as a taxi of PHV.
  #
  # ==== Usage
  #    SessionManipulation::SetTaxi.call(session: session)
  #
  class SetTaxi < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 2

    # Sets +taxi+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(taxi: true)
    end
  end
end
