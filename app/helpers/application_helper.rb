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
    weekly_period ? select_weekly_date_dates_path : select_daily_date_dates_path
  end

  # Used for external inline links in the app.
  # Returns a link with blank target and area-label.
  #
  # Reference: https://www.w3.org/WAI/GL/wiki/Using_aria-label_for_link_purpose
  def external_link_to(text, url, html_options = {})
    html_options.symbolize_keys!.reverse_merge!(
      target: '_blank',
      class: 'govuk-link',
      rel: 'noopener',
      'area-label': "#{html_options[:'area-label'] || text} - #{I18n.t('external_link')}"
    )
    link_to text, url, html_options
  end

  # Returns content for title with global app name.
  def page_title(title_text)
    content_for(:title, "#{title_text} | Pay a Clean Air Zone Charge")
  end
end
