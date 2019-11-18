# frozen_string_literal: true

module SessionManipulation
  class AddVrn < BaseManipulator
    LEVEL = 1

    def initialize(session:, form:)
      @session = session
      @vrn = form.vrn
      @country = form.country
    end

    def call
      log_action "Adding #{starting_values}"
      session[SESSION_KEY] = starting_values
    end

    private

    def starting_values
      { 'vrn' => vrn, 'country' => country }
    end

    attr_reader :vrn, :country
  end
end
