# frozen_string_literal: true

class VehicleCheckersController < ApplicationController
  ##
  # Renders the first step of checking the vehicle compliance.
  # If it was called using GET method, it clears @errors variable.
  #
  # ==== Path
  #    GET /vehicle_checkers/enter_details
  #
  def enter_details
    @errors = {}
  end

  ##
  # Validates submitted VRN. If successful, adds submitted VRN to the session and
  # redirects to {confirm details}[rdoc-ref:VehicleCheckersController.confirm_details].
  #
  # Any invalid params values triggers rendering {enter details}[rdoc-ref:VehicleCheckersController.enter_details]
  # with @errors displayed.
  #
  # Selecting NON-UK vehicle redirects to a {non-uk page}[rdoc-ref:VehicleCheckersController.non_uk]
  #
  # ==== Path
  #
  #    POST /vehicle_checkers/validate_vrn
  #
  # GET method redirects to {enter details}[rdoc-ref:VehicleCheckersController.enter_details]
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, string, required in the query
  # * +registration-country+ - country of the vehicle registration, UK or NON-UK, required in the query
  #
  # ==== Validations
  # Validations are done by {VrnForm}[rdoc-ref:VrnForm]
  #
  def validate_vrn
    form = VrnForm.new(params_vrn, country)
    unless form.valid?
      @errors = form.error_object
      render enter_details_vehicle_checkers_path
    end

    redirect_to root_path
    # session[:vrn] = params_vrn
    # redirect_to non_uk? ? non_uk_vehicle_checkers_path : confirm_details_vehicle_checkers_path
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
end
