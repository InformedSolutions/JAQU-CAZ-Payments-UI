# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to add email submitted by the user on Gov.UK Pay.
  #
  # ==== Usage
  #    SessionManipulation::SetUserEmail.call(session: session, email: 'test@example.com')
  #
  class SetPaymentDetails < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 15

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +email+ - an email address
    #
    def initialize(session:, email:, payment_reference:, external_id:)
      @session = session
      @email = email
      @payment_reference = payment_reference
      @external_id = external_id
    end

    # Adds the +user_email+, +payment_reference+ and +external_id+ to the session
    # Used by the class level method +.call+
    def call
      add_fields(user_email: email, payment_reference: payment_reference, external_id: external_id)
    end

    private

    # Get function for the email
    attr_reader :email, :payment_reference, :external_id
  end
end
