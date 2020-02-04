# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to mark vehicle's details as incorrect.
  #
  # ==== Usage
  #    SessionManipulation::SetIncorrect.call(session: session)
  #
  class SetIncorrect < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 4

    # Sets +incorrect+ to true in the session. Used by the class level method +.call+
    #
    # Also, it clears marking as unrecognized as those labels can go together.
    #
    def call
      # Can not be both unrecognised and incorrect
      session[SESSION_KEY] = session[SESSION_KEY].except('unrecognised')
      add_fields(incorrect: true)
    end
  end
end
