# frozen_string_literal: true

##
# Controls the first steps of the payment process regarding user's vehicle data.
#
class VehiclesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn, except: %i[enter_details submit_details]

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
  # redirects to {details}[rdoc-ref:VehiclesController.details].
  #
  # Any invalid params values triggers rendering {enter details}[rdoc-ref:VehiclesController.enter_details]
  # with @errors displayed.
  #
  # Selecting NON-UK vehicle redirects to a {non-uk page}[rdoc-ref:VehiclesController.non_uk]
  #
  # ==== Path
  #
  #    POST /vehicles/submit_details
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
  def submit_details
    form = VrnForm.new(params_vrn, country)
    unless form.valid?
      @errors = form.errors.messages
      log_invalid_form 'Rendering :enter_details.'
      return render enter_details_vehicles_path
    end

    store_vrn
    redirect_to non_uk? ? non_uk_vehicles_path : details_vehicles_path
  end

  ##
  # Renders vehicle details form.
  #
  # ==== Path
  #
  #    GET /vehicles/details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  def details
    @vehicle_registration = vrn
  end

  ##
  # Verifies if user confirms the vehicle's details.
  # If yes, renders to {incorrect details}[rdoc-ref:VehiclesController.local_authority]
  # If no, redirects to {incorrect details}[rdoc-ref:VehiclesController.incorrect_details]
  #
  # ==== Path
  #    POST /vehicles/confirm_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-vehicle+ - user confirmation of vehicle details, 'yes' or 'no', required in the query
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-vehicle+ - lack of it redirects to {incorrect details}[rdoc-ref:VehiclesController.incorrect_details]
  #
  def confirm_details
    form = ConfirmationForm.new(confirmation)
    unless form.valid?
      log_invalid_form 'Redirecting back.'
      return redirect_to details_vehicles_path, alert: form.message
    end

    redirect_to form.confirmed? ? local_authorities_path : incorrect_details_vehicles_path
  end

  ##
  # Renders a static page for users who selected that DVLA data in incorrect.
  #
  # ==== Path
  #
  #    GET /vehicles/incorrect_details
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def incorrect_details
    # to be defined later
  end

  private

  # Returns uppercased VRN from the query params, eg. 'CU1234'
  def params_vrn
    params[:vrn].upcase
  end

  # Stores VRN in the session
  def store_vrn
    session[:vrn] = params_vrn
  end

  # Returns user's form confirmation from the query params, values: 'yes', 'no', nil
  def confirmation
    params['confirm-vehicle']
  end

  # Returns vehicles's registration country from the query params, values: 'UK', 'Non-UK', nil
  def country
    params['registration-country']
  end

  # Checks if selected registration country equals Non-UK.
  # Returns boolean.
  def non_uk?
    country == 'Non-UK'
  end
end
