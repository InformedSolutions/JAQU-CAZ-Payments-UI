# frozen_string_literal: true

##
# Controls the first steps of the payment process regarding user's vehicle data.
#
class VehiclesController < ApplicationController
  # 404 HTTP status from API mean vehicle in not found in DLVA database. Redirects to the proper page.
  rescue_from BaseApi::Error404Exception, with: :vehicle_not_found

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
    @return_url = request.referer ? determinate_back_path : root_path
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
    form = VrnForm.new(params[:vrn], country)
    return rerender_enter_details(form) unless form.valid?

    SessionManipulation::AddVrn.call(session: session, form: form)
    redirect_to non_uk? ? non_dvla_vehicles_path : details_vehicles_path
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
    @vehicle_details = VehicleDetails.new(vrn)
    return redirect_to(exempt_vehicles_path) if @vehicle_details.exempt?

    SessionManipulation::SetLeedsTaxi.call(session: session) if @vehicle_details.leeds_taxi?
    SessionManipulation::SetType.call(session: session, type: @vehicle_details.type)
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
      return redirect_to details_vehicles_path, alert: form.errors.messages[:confirmation].first
    end

    redirect_to form.confirmed? ? local_authority_charges_path : incorrect_details_vehicles_path
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
    # Used to determine the previous step in ChargesController#local_authority
    SessionManipulation::SetIncorrect.call(session: session)
  end

  ##
  # Renders a static page for users who selected that DVLA data is incorrect.
  #
  # ==== Path
  #
  #    GET /vehicles/unrecognised
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def unrecognised
    SessionManipulation::SetUnrecognised.call(session: session)
    @vrn = vrn
  end

  ##
  # Verifies if user confirms that the registration number is correct.
  # If yes, renders to {choose type}[rdoc-ref:NonDvlaVehiclesController.choose_type]
  # If no, redirects to {non_dvla_vehicles}[rdoc-ref:VehiclesController.unrecognised]
  #
  # ==== Path
  #    POST /vehicles/confirm_unrecognised
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-registration+ - user confirmation that the registration number is correct.
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-registration+ - lack of it redirects to {non_dvla_vehicles}[rdoc-ref:VehiclesController.unrecognised]
  #
  def confirm_unrecognised
    form = ConfirmationForm.new(params['confirm-registration'])
    if form.confirmed?
      redirect_to choose_type_non_dvla_vehicles_path
    else
      log_invalid_form 'Redirecting back.'
      redirect_to unrecognised_vehicles_path, alert: true
    end
  end

  ##
  # Renders a static page for users which VRN is recognised as compliant (no charge in all LAs)
  #
  # ==== Path
  #
  #    GET /vehicles/compliant
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def compliant
    # renders the static page
  end

  private

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

  # Redirects to {vehicle not found}[rdoc-ref:VehiclesController.unrecognised_vehicle]
  def vehicle_not_found
    redirect_to unrecognised_vehicles_path
  end

  # Renders enter_details page and log errors
  def rerender_enter_details(form)
    @errors = form.errors.messages
    log_invalid_form 'Rendering :enter_details.'
    render enter_details_vehicles_path
  end

  # Returns path depends on last request
  def determinate_back_path
    last_request = request.referer
    if back_button_paths.any? { |path| last_request.include?(path) }
      last_request
    else
      root_path
    end
  end

  # back button paths on enter details page
  def back_button_paths
    [
      non_dvla_vehicles_path,
      incorrect_details_vehicles_path,
      unrecognised_vehicles_path,
      compliant_vehicles_path,
      exempt_vehicles_path
    ]
  end
end
