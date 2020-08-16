# frozen_string_literal: true

##
# Base module for helpers, generated automatically during new application creation.
#
module ApplicationHelper
  # Returns name of service, eg. 'Drive in a Clean Air Zone'.
  def service_name
    Rails.configuration.x.service_name
  end

  # rubocop:disable Style/AsciiComments
  # Returns parsed string, eg. '£10.00'
  # rubocop:enable Style/AsciiComments
  def parse_charge(value)
    "£#{format('%<pay>.2f', pay: value.to_f)}"
  end

  # Returns collection of parsed dates, eg. ['Friday 11 October 2019']
  def parse_dates(dates)
    dates.map do |date_string|
      parse_single_date(date_string)
    end
  end

  # Returns parsed date format, eg. 'Friday 11 October 2019'
  def parse_single_date(date_string)
    date_string.to_date.strftime('%A %d %B %Y')
  end

  # Returns url path depends on which period was selected
  def determinate_payment_for_path(weekly_period, weekly_charge_today, new_id)
    if weekly_period && weekly_charge_today
      select_weekly_period_dates_path(id: new_id, new: true)
    elsif weekly_period && !weekly_charge_today
      select_weekly_date_dates_path(id: new_id, change: true, new: true)
    else
      select_daily_date_dates_path(id: new_id, new: true)
    end
  end

  # Returns content for title with global app name.
  def page_title(title_text)
    content_for(:title, "#{title_text} | #{service_name}")
  end

  # Return link to proper DVLA contact form from env variables
  def link_to_dvla_contact_form
    link_to 'DVLA', ENV.fetch('DVLA_CONTACT_URL', 'https://contact-preprod.dvla.gov.uk/'), id: 'dvla-link'
  end
end
