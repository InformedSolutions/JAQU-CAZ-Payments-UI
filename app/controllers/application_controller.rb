# frozen_string_literal: true

class ApplicationController < ActionController::Base
  private

  # Logs invalid form on +warn+ level
  def log_invalid_form(msg)
    Rails.logger.warn("The form is invalid. #{msg}")
  end

  # Gets VRN from session. Returns string, eg 'CU1234'
  def vrn
    session[:vrn]
  end

  # Checks if VRN is present in session.
  # If not, redirects to VehiclesController#enter_details
  def check_vrn
    return if vrn

    Rails.logger.warn 'VRN is missing in the session. Redirecting to :enter_details'
    redirect_to enter_details_vehicles_path
  end
end
