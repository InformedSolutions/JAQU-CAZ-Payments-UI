# frozen_string_literal: true

##
# Controls the flow for vehicles not registered in the UK
#
class NonUkVehiclesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn

  ##
  # Renders a page for vehicles that are not registered within the UK.
  #
  # ==== Path
  #
  #    GET /non_uk_vehicles
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def index
    @vehicle_registration = vrn
  end

  ##
  # Verifies if user confirms that the registration number is correct.
  # If yes, renders to {choose type}[rdoc-ref:NonUkVehiclesController.choose_type]
  # If no, redirects to {non_uk_vehicles}[rdoc-ref:NonUkVehiclesController.index]
  #
  # ==== Path
  #    POST /non_uk_vehicles/confirm_registration
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +confirm-registration+ - user confirmation that the registration number is correct.
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-registration+ - lack of it redirects to {non_uk_vehicles}[rdoc-ref:NonUkVehiclesController.index]
  #
  def confirm_registration
    if registration_not_confirmed?
      redirect_to non_uk_vehicles_path, alert: true
    else
      redirect_to choose_type_non_uk_vehicles_path
    end
  end

  ##
  # Renders choose vehicle type page.
  #
  # ==== Path
  #    GET /non_uk_vehicles/choose_type
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def choose_type
    # renders a static page
  end

  ##
  # Verifies if user choose a type of vehicle.
  # If yes, renders {local authorities}[rdoc-ref:LocalAuthoritiesController.index]
  # If no, redirects to {choose_type}[rdoc-ref:NonUkVehiclesController.choose_type]
  #
  # ==== Path
  #    POST /non_uk_vehicles/submit_type
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +vehicle-type+ - user's type of vehicle
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +vehicle-type+ - lack of it redirects to {choose_type}[rdoc-ref:NonUkVehiclesController.choose_type]
  #
  def submit_type
    if params['vehicle-type'].blank?
      redirect_to choose_type_non_uk_vehicles_path, alert: true
    else
      redirect_to local_authorities_path
    end
  end

  private

  # Checks if confirm registration not equals 'true'.
  # Returns boolean.
  def registration_not_confirmed?
    params['confirm-registration'] != 'true'
  end
end
