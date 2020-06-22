# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to confirm registration number correct.
  #
  # ==== Usage
  #    SessionManipulation::SetConfirmRegistration.call(session: session)
  #
  class SetConfirmRegistration < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 3

    # Sets +confirm_registration+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(confirm_registration: true)
    end
  end
end
