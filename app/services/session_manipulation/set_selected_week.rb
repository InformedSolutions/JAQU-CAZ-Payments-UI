# frozen_string_literal: true

module SessionManipulation
  ##
  # Service used to set currently selected week for weekly payments.
  #
  # ==== Usage
  #    SessionManipulation::SetSelectedWeek.call(session: session, second_week_selected: true)
  #
  class SetSelectedWeek < BaseManipulator
    # Level used to clearing keys in the session
    LEVEL = 13

    # Initializer function. Used by the class level method +.call+
    #
    # ==== Attributes
    # * +session+ - the user's session
    # * +second_week_selected+ - boolean, whether dates for second week are being selected
    #
    def initialize(session:, second_week_selected: false)
      @session = session
      @second_week_selected = second_week_selected
    end

    # Adds the +second_week_selected+ to the session. Used by the class level method +.call+
    def call
      session[:second_week_selected] = @second_week_selected
      session[:second_week_start_date] = nil if @second_week_selected == false
    end
  end
end
