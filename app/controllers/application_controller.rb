# frozen_string_literal: true

##
# Base controller class. Contains common functions.
#
# Also, contains some basic endpoints used for build purposes.
#
class ApplicationController < ActionController::Base
  # Escapes all API related error with rendering 503 page
  rescue_from Errno::ECONNREFUSED,
              SocketError,
              BaseApi::Error500Exception,
              BaseApi::Error422Exception,
              BaseApi::Error400Exception,
              with: :redirect_to_server_unavailable

  # enable basic HTTP authentication on production environment if HTTP_BASIC_PASSWORD variable present
  http_basic_authenticate_with name: ENV['HTTP_BASIC_USER'],
                               password: ENV['HTTP_BASIC_PASSWORD'],
                               except: %i[build_id health],
                               if: lambda {
                                     Rails.env.production? && ENV['HTTP_BASIC_PASSWORD'].present?
                                   }
  before_action :check_for_new_id, except: [:health, :build_id]
  around_action :handle_history, except: [:health, :build_id]

  ##
  # Health endpoint
  #
  # Used as a healthcheck - returns 200 HTTP status
  #
  # ==== Path
  #
  #    GET /health.json
  #
  def health
    puts "hello world"
    render json: 'OK', status: :ok
  end

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

  # Logs an exception and redirects to service unavailable page.
  # Used to escape API calls related exceptions.
  def redirect_to_server_unavailable(exception)
    Rails.logger.error "#{exception.class}: #{exception.message}"

    render template: 'errors/service_unavailable', status: :service_unavailable
  end

  # Gets VRN from vehicle_details hash in the session. Returns string, eg 'CU1234'
  def vrn
    vehicle_details('vrn')
  end

  # Gets LA name from vehicle_details hash in the session. Returns string, eg 'Leeds'
  def la_name
    vehicle_details('la_name')
  end

  # Gets if weekly charge is possible
  def weekly_possible
    vehicle_details('weekly_possible')
  end

  # Checks if VRN is present in session.
  # If not, redirects to VehiclesController#enter_details
  def check_vrn
    return if vrn

    redirect_to_enter_details('VRN')
  end

  # Logs warning and redirects enter_details page
  def redirect_to_enter_details(value)
    Rails.logger.warn("#{value} is missing in the session. Redirecting to :enter_details")
    redirect_to enter_details_vehicles_path
  end

  # Checks if LA ID, la name and daily_charge are present in the session.
  # If not, redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  def check_compliance_details
    return if la_id && la_name && charge

    Rails.logger.warn(
      'Compliance details are missing in the session. Redirecting to :local_authority'
    )
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


  # Gets charge from vehicle_details hash in the session. Returns integer, eg 50
  def charge
    vehicle_details('daily_charge')
  end

  # Logs and redirects to +path+
  def redirect_back_to(path, alert, template)
    Rails.logger.warn("The form is invalid. Redirecting back to :#{template}")
    redirect_to path, alert: alert
  end

  # Assign back button url
  def assign_back_button_url
    @back_button_url = request.referer || root_path
  end

  # Get query parameter from request
  def get_query_parameter(parameter)
    last_request = request.referer
    parameter_exists = request.query_parameters.include?(parameter)
    if parameter_exists
      request.query_parameters[parameter]
    end
  end

  def transaction_id
    session[:transaction_id]
  end

  def url_id
    get_query_parameter('id')
  end

  def check_for_new_id
    session[:transaction_id] ||= SecureRandom.uuid
    session[:transaction_id] = url_id if get_query_parameter('new') == 'true'
  end

    # Handle history of the flow through the process - used by back links
  def handle_history # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # We make a copy of session data here as we want to know
    # its state from very beginning of the request
    session[:history] ||= {}

    # We need to restore session data if this is page after navigating "back"
    # before any other actions run
    if request.method == 'GET'
      if restore_history_entry?
        session[:vehicle_details] = session[:history][url_id]
      else
        session[:history][transaction_id] = Marshal.load(Marshal.dump(session[:vehicle_details]))
      end
    end

    yield
  end

  # Checks if history should be restored
  def restore_history_entry?
      url_id &&
        !transaction_id.eql?(url_id)
  end

  # set headers for pages that should be refreshed every time
  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end
end
