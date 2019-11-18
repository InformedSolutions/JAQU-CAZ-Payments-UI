# frozen_string_literal: true

module SessionManipulation
  class SetUserEmail < BaseManipulator
    LEVEL = 7

    def initialize(session:, email:)
      @session = session
      @email = email
    end

    def call
      add_fields(user_email: email)
    end

    private

    attr_reader :email
  end
end
