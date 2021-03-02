# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark vehicle as a taxi of PHV registered in Taxidiscountcaz.
  #
  # ==== Usage
  #    SessionManipulation::SetWeeklyTaxi.call(session: session)
  #
  class SetWeeklyTaxi < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 3

    # Sets +weekly_taxi+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(weekly_taxi: true)
    end
  end
end
