# frozen_string_literal: true

##
# Helper module for DatesController
module DatesHelper
  # Checks if the date was already selected by the user.
  # Returns boolean.
  def checked_daily?(value)
    session.dig(:vehicle_details, 'dates')&.include?(value)
  end

  # Checks if the date is the beginning of the previously selected period.
  # Returns boolean.
  def checked_weekly?(value)
    value == session.dig(:vehicle_details, 'dates')&.first
  end

  # Returns the date's name with today and paid marks
  def display_date(date)
    value = date[:today] ? content_tag(:b, date[:name]) + ' (Today)' : date[:name]
    value += ' - Paid' if date[:disabled]
    value
  end
end
