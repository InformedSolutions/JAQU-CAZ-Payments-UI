# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to set the vehicle's type submitted by the user
  # for vehicles not being present in the DVLA database.
  #
  # ==== Usage
  #    SessionManipulation::SetType.call(session: session, type: 'Car')
  #
  class SetType < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 5

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +type+ - string, selected type of a vehicle, eg. 'Car'
    #
    def initialize(session:, type:)
      @session = session
      @type = type
    end

    # Adds the +type+ to the session. Used by the class level method +.call+
    def call
      add_fields(type: type)
    end

    private

    # Get function for the type
    attr_reader :type
  end
end
