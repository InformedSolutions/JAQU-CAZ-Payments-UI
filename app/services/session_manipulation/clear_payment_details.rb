# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to clear the payment details after success or failure of it.
  #
  # It keeps keys from steps before selecting LA for the button to return to LA picking
  #
  # ==== Usage
  #    SessionManipulation::ClearPaymentDetails.call(session: session)
  #
  class ClearPaymentDetails < BaseManipulator
    # It clears keys in the session hash the were set after setting compliance details
    def call
      log_action 'Clearing data from the session'
      session[SESSION_KEY] = session[SESSION_KEY].slice(*keys_to_keep)
      log_action "User's current session: #{session[SESSION_KEY]}"
    end

    private

    # Returns keys from steps before selecting LA
    def keys_to_keep
      SUBKEYS.select { |key| key < 4 }.values.flatten
    end
  end
end
