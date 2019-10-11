# frozen_string_literal: true

##
# Base module for helpers, generated automatically during new application creation.
#
module ApplicationHelper
  # Returns name of service, eg. 'Pay a Clean Air Zone charge'.
  def service_name
    Rails.configuration.x.service_name
  end
end
