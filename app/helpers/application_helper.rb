# frozen_string_literal: true

##
# Base module for helpers, generated automatically during new application creation.
#
module ApplicationHelper
  # Returns name of service, eg. 'Pay a Clean Air Zone charge'.
  def service_name
    Rails.configuration.x.service_name
  end

  # rubocop:disable Style/AsciiComments
  # Returns parsed string, eg. '£10.00'
  # rubocop:enable Style/AsciiComments
  def parse_charge(value)
    "£#{format('%<pay>.2f', pay: value.to_f)}"
  end

  # Returns parsed date format, eg. 'Friday 11 October 2019'
  def parse_dates(dates)
    dates.map do |date_string|
      date_string.to_date.strftime('%A %d %B %Y')
    end
  end

  # Returns url path depends on which period was selected
  def determinate_payment_for_path(weekly_period)
    weekly_period ? select_period_dates_path : select_daily_date_dates_path
  end
end
