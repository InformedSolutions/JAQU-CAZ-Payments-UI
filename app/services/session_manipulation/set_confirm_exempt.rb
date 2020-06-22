# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to confirm not locally exempt.
  #
  # ==== Usage
  #    SessionManipulation::SetConfirmExempt.call(session: session)
  #
  class SetConfirmExempt < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 10

    # Sets +confirm_exempt+ to true in the session. Used by the class level method +.call+
    def call
      add_fields(confirm_exempt: true)
    end
  end
end
