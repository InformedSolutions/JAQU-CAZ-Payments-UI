# frozen_string_literal: true

##
# Base controller class. Contains common functions.
#
# Also, contains some basic endpoints used for build purposes.
#
class ApplicationController < ActionController::Base
  rescue_from Errno::ECONNREFUSED,
              SocketError,
              BaseApi::Error500Exception,
              BaseApi::Error422Exception,
              BaseApi::Error400Exception,
              with: :redirect_to_server_unavailable

  ##
  # Build ID endpoint
  #
  # Used by CI to determine if the new version is already deployed.
  # +BUILD_ID+ environment variables is used to set it's value. If nothing is set, returns 'undefined
  #
  # ==== Path
  #
  #    GET /build_id.json
  #
  def build_id
    render json: ENV.fetch('BUILD_ID', 'undefined'), status: :ok
  end

  private

  def redirect_to_server_unavailable(exception)
    Rails.logger.error "#{exception.class}: #{exception.message}"

    render template: 'errors/service_unavailable', status: :service_unavailable
  end

  # Logs invalid form on +warn+ level
  def log_invalid_form(msg)
    Rails.logger.warn("The form is invalid. #{msg}")
  end

  # Gets VRN from vehicle_details hash in the session. Returns string, eg 'CU1234'
  def vrn
    vehicle_details('vrn')
  end

  # Gets LA name from vehicle_details hash in the session. Returns string, eg 'Leeds'
  def la_name
    vehicle_details('la_name')
  end

  # Checks if VRN is present in session.
  # If not, redirects to VehiclesController#enter_details
  def check_vrn
    return if vrn

    Rails.logger.warn 'VRN is missing in the session. Redirecting to :enter_details'
    redirect_to enter_details_vehicles_path
  end

  # Checks if LA ID is present in the session.
  # If not, redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  def check_la_id
    return if la_id

    Rails.logger.warn 'LA ID is missing in the session. Redirecting to :local_authority'
    redirect_to local_authority_charges_path
  end

  # Gets LA from vehicle_details hash in the session. Returns string, eg '39e54ed8-3ed2-441d-be3f-38fc9b70c8d3'
  def la_id
    vehicle_details('la_id')
  end

  # Returns hash's value for current +field+
  def vehicle_details(field)
    session.dig(:vehicle_details, field)
  end

  # Checks if LA name is present in the session
  def check_la_name
    return if la_name

    Rails.logger.warn 'LA NAME is missing in the session. Redirecting to :enter_details'
    redirect_to enter_details_vehicles_path
  end

  # Checks if charge is present in the session
  def check_charge
    return if charge

    Rails.logger.warn 'CHARGE is missing in the session. Redirecting to :enter_details'
    redirect_to enter_details_vehicles_path
  end

  # Gets charge from vehicle_details hash in the session. Returns integer, eg 50
  def charge
    vehicle_details('charge')
  end
end
