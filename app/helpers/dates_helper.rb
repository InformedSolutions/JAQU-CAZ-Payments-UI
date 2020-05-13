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

  # Checks if vehicle details are undetermined
  # Returns boolean.
  def undetermined_vehicle?
    session.dig(:vehicle_details, 'undetermined').present?
  end

  # Returns the date's name with today and paid marks
  def display_date(date)
    value = today_not_paid(date) ? content_tag(:b, date[:name]) : date[:name]
    value += ' (Today)' if date[:today]
    value += ' - Paid' if date[:disabled]
    value
  end

  private

  def today_not_paid(date)
    date[:today] & !date[:disabled]
  end
end
