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

  # Returns today hint, e.g. 'Your weekly charge will expire on Tue 09 June 2020'
  # Renders on app/views/dates/select_weekly_period.html.haml view
  def today_hint
    end_date = (Date.current + 6.days).strftime('%a %d %B %Y')
    "Your weekly charge will expire on #{end_date}"
  end

  private

  # Checks if today day is not paid
  def today_not_paid(date)
    date[:today] & !date[:disabled]
  end
end
