# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to add email submitted by the user on Gov.UK Pay.
  #
  # ==== Usage
  #    SessionManipulation::SetUserEmail.call(session: session, email: 'test@example.com')
  #
  class SetUserEmail < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 8

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +email+ - an email address
    #
    def initialize(session:, email:)
      @session = session
      @email = email
    end

    # Adds the +user_email+ to the session. Used by the class level method +.call+
    def call
      add_fields(user_email: email)
    end

    private

    # Get function for the email
    attr_reader :email
  end
end
