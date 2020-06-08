# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to add submitted by user VRN and registration country.
  #
  # It clears all other keys.
  #
  # ==== Usage
  #    form = VrnForm.new(vrn, country)
  #    if form.valid?
  #       SessionManipulation::AddVrn.call(session: session, form: form)
  #    end
  #
  class AddVrn < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 1

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +form+ - a valid instance of VrnForm
    #
    def initialize(session:, form:)
      @session = session
      @vrn = form.vrn
      @country = form.country
    end

    # Adds +VRN+ and +country+ to the session. Used by the class level method +.call+
    def call
      log_action("Adding keys: #{starting_values.keys} to the session")
      session[SESSION_KEY] = starting_values
      log_action("Current session keys: #{session[SESSION_KEY].keys}")
    end

    private

    # Hash containing submitted VRN and country
    def starting_values
      { 'vrn' => vrn, 'country' => country }
    end

    # Get functions for VRN and country
    attr_reader :vrn, :country
  end
end
