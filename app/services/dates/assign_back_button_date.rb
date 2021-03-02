# frozen_string_literal: true

module Dates
  ##
  # Class is used to hold dates of Discounted Taxi weekly selections to use them after back button click
  #
  # ==== Usage
  #
  #    Dates::AssignBackButtonDate.call(session: session, second_week_selected: false)
  #
  # ==== Params
  # * +session+ - session
  # * +second_week_selected+ - boolean, specifies handled week. nil value clears both dates
  #
  class AssignBackButtonDate < BaseService
    include DatesHelper

    def initialize(session:, second_week_selected: nil)
      @session = session
      @second_week_selected = second_week_selected
    end

    # Handles week dates of selected week
    def call
      if second_week_selected == false
        handle_first_week
      elsif second_week_selected
        handle_second_week
      elsif second_week_selected.nil?
        clear_back_button_dates
      end
    end

    private

    attr_reader :session, :second_week_selected

    # Stores first week back button date
    # Removes all selected dates from session
    def handle_first_week
      session[:first_week_back_button] = session[:first_week_start_date]
      session[:first_week_start_date] = nil
      session[:vehicle_details]['dates'] = []
    end

    # Stores second week back button date
    # Removes second week dates from session
    def handle_second_week
      session[:second_week_back_button] = session[:second_week_start_date]
      session[:second_week_start_date] = nil
      session[:vehicle_details]['dates'] = disable_week(session[:first_week_start_date])
    end

    # Clears both weeks back button dates
    def clear_back_button_dates
      session[:first_week_back_button] = nil
      session[:second_week_back_button] = nil
    end
  end
end
