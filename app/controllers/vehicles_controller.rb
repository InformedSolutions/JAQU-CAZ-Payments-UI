# frozen_string_literal: true

class VehiclesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn, except: %i[enter_details validate_details]

  ##
  # Renders the first step of checking the vehicle compliance.
  # If it was called using GET method, it clears @errors variable.
  #
  # ==== Path
  #    GET /vehicles/enter_details
  #
  def enter_details
    @errors = {}
  end

  ##
  # Validates submitted VRN. If successful, adds submitted VRN to the session and
  # redirects to {confirm details}[rdoc-ref:VehiclesController.confirm_details].
  #
  # Any invalid params values triggers rendering {enter details}[rdoc-ref:VehiclesController.enter_details]
  # with @errors displayed.
  #
  # Selecting NON-UK vehicle redirects to a {non-uk page}[rdoc-ref:VehiclesController.non_uk]
  #
  # ==== Path
  #
  #    POST /vehicles/validate_details
  #
  # GET method redirects to {enter details}[rdoc-ref:VehiclesController.enter_details]
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, string, required in the query
  # * +registration-country+ - country of the vehicle registration, UK or NON-UK, required in the query
  #
  # ==== Validations
  # Validations are done by {VrnForm}[rdoc-ref:VrnForm]
  #
  def validate_details
    form = VrnForm.new(params_vrn, country)
    unless form.valid?
      @errors = form.error_object
      log_invalid_form 'Rendering :enter_details.'
      return render enter_details_vehicles_path
    end

    session[:vrn] = params_vrn
    redirect_to non_uk? ? non_uk_vehicles_path : confirm_details_vehicles_path
  end

  ##
  # Renders vehicle details form.
  #
  # ==== Path
  #
  #    GET /vehicles/confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def confirm_details
    @vehicle_registration = vrn
  end

  ##
  # Renders a page for vehicles that are not registered within the UK.
  #
  # ==== Path
  #
  #    GET /vehicles/non_uk
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  def non_uk
    @vehicle_registration = vrn
  end

  ##
  # Renders a choose vehicle page for Non-UK vehicle.
  #
  # ==== Path
  #
  #    POST /vehicles/choose_vehicle
  #
  # ==== Params
  # * +confirm-registration+ - confirmation that vehicle not registered in the UK
  #
  # ==== Validations
  # * +confirm-registration+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.non_uk]
  def choose_vehicle
    if registration_not_confirmed?
      redirect_to non_uk_vehicles_path, alert: 'Confirm that the registration number is correct'
    end
  end

  # Checks if VRN is present in session.
  # If not, redirects to VehiclesController#enter_details
  def check_vrn
    return if vrn

    Rails.logger.warn 'VRN is missing in the session. Redirecting to :enter_details'
    redirect_to enter_details_vehicles_path
  end

  private

  # Returns uppercased VRN from the query params, eg. 'CU1234'
  def params_vrn
    params[:vrn].upcase
  end

  # Returns vehicles's registration country from the query params, values: 'UK', 'Non-UK', nil
  def country
    params['registration-country']
  end

  # Gets VRN from session. Returns string, eg 'CU1234'
  def vrn
    session[:vrn]
  end

  # Checks if selected registration country equals Non-UK.
  # Returns boolean.
  def non_uk?
    country == 'Non-UK'
  end

  # Checks if confirm registration not equals 'true'.
  # Returns boolean.
  def registration_not_confirmed?
    params['confirm-registration'] != 'true'
  end
end
