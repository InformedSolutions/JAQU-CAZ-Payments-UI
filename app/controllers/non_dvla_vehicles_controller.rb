# frozen_string_literal: true

##
# Controls the flow for vehicles not registered in the UK and those which are not found in the DVLA database
#
class NonDvlaVehiclesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn

  ##
  # Renders a page for vehicles that are not registered within the UK.
  #
  # ==== Path
  #
  #    GET /non_dvla_vehicles
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def index
    @vehicle_registration = vrn
    register_details = RegisterDetails.new(vrn)
    return unless register_details.register_compliant? || register_details.register_exempt?

    redirect_to(exempt_vehicles_path(id: transaction_id))
  end

  ##
  # Verifies if user confirms that the registration number is correct.
  # If yes, renders to {choose type}[rdoc-ref:NonDvlaVehiclesController.choose_type]
  # If no, redirects to {non_dvla_vehicles}[rdoc-ref:NonDvlaVehiclesController.index]
  #
  # ==== Path
  #    POST /non_dvla_vehicles/confirm_registration
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-registration+ - user confirmation that the registration number is correct.
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-registration+ - lack of it redirects to {non_dvla_vehicles}[rdoc-ref:NonDvlaVehiclesController.index]
  #
  def confirm_registration
    form = ConfirmationForm.new(params['confirm-registration'])
    if form.confirmed?
      SessionManipulation::SetConfirmRegistration.call(session: session)
      redirect_to choose_type_non_dvla_vehicles_path(id: transaction_id)
    else
      redirect_to non_dvla_vehicles_path(id: transaction_id), alert: true
    end
  end

  ##
  # Renders choose vehicle type page.
  #
  # ==== Path
  #    GET /non_dvla_vehicles/choose_type
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def choose_type
    @return_path = choose_type_return_path
    @types = VehicleTypes.call
  end

  ##
  # Verifies if user choose a type of vehicle.
  # If yes, renders {local authorities}[rdoc-ref:LocalAuthoritiesController.index]
  # If no, redirects to {choose_type}[rdoc-ref:NonDvlaVehiclesController.choose_type]
  #
  # ==== Path
  #    POST /non_dvla_vehicles/submit_type
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +vehicle-type+ - user's type of vehicle
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +vehicle-type+ - lack of it redirects to {choose_type}[rdoc-ref:NonDvlaVehiclesController.choose_type]
  #
  def submit_type
    type = params['vehicle-type']
    if type.blank?
      redirect_to choose_type_non_dvla_vehicles_path(id: transaction_id), alert: true
    else
      SessionManipulation::SetType.call(session: session, type: type)
      redirect_to local_authority_charges_path(id: transaction_id)
    end
  end

  private

  def choose_type_return_path
    if vehicle_details('unrecognised')
      unrecognised_vehicles_path
    elsif vehicle_details('possible_fraud')
      uk_registered_details_vehicles_path
    else
      non_dvla_vehicles_path
    end
  end
end
