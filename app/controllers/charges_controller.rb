# frozen_string_literal: true

##
# Controls selecting LAs where the user wants to pay for.
#
class ChargesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn

  # checks if LA is present in the session
  before_action :check_la, only: :dates

  ##
  # Renders the list of available local authorities.
  #
  # ==== Path
  #    GET /charges/local_authority
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def local_authority
    @zones = ComplianceCheckerApi.chargeable_clean_air_zones(vrn)
    return redirect_to compliant_vehicles_path if @zones.empty?

    @zones = @zones.map { |caz_data| Caz.new(caz_data) }
    @return_path = request.referer || enter_details_vehicles_path
  end

  ##
  # Validates and stores the selected local authority.
  # If successful, redirects to {picking dates}[rdoc-ref:ChargesController.dates]
  #
  # ==== Path
  #    POST /charges/submit_local_authority
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +local-authority+ - selected local authority, required in query params
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +local-authority+ - lack of LA redirects back to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def submit_local_authority
    form = LocalAuthorityForm.new(params['local-authority'])
    unless form.valid?
      log_invalid_form 'Redirecting to :local_authority.'
      return redirect_to local_authority_charges_path, alert: la_alert(form)
    end

    store_la
    redirect_to dates_charges_path
  end

  ##
  # Renders the list of dates to pick.
  #
  # ==== Path
  #    GET /charges/dates
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +la+ - selected local authority, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def dates
    @local_authority = session[:la]
  end

  private

  def la_alert(form)
    form.errors.messages[:authority].first
  end

  def store_la
    session[:la] = params['local-authority']
  end

  def check_la
    return if session[:la]

    Rails.logger.warn 'LA is missing in the session. Redirecting to :local_authority'
    redirect_to local_authority_charges_path
  end
end
