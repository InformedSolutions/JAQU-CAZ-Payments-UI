# frozen_string_literal: true

##
# Controls selecting LAs where the user wants to pay for.
#
class ChargesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn

  # checks if LA is present in the session
  before_action :check_la, except: %i[local_authority submit_local_authority]

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
    zones_data = ComplianceCheckerApi.chargeable_zones(vrn)
    return redirect_to compliant_vehicles_path if zones_data.empty?

    @zones = zones_data.map { |caz_data| Caz.new(caz_data) }
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
    if form.valid?
      store_la
      redirect_to daily_charge_charges_path
    else
      log_invalid_form 'Redirecting to :local_authority.'
      redirect_to local_authority_charges_path, alert: la_alert(form)
    end
  end

  ##
  # Renders the charge value for a given LA.
  #
  # ==== Path
  #    GET /charges/daily_charge
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +la+ - selected local authority, required in the session
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def daily_charge
    @compliance_details = ComplianceDetails.new(vrn, session[:la])
  end

  ##
  # Validates if user confirmed being not exempt for a given LA.
  # If yes, redirects to the {next step}[rdoc-ref:ChargesController.dates]
  #
  # ==== Path
  #    POST /charges/confirm_daily_charge
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +la+ - selected local authority, required in the session
  # * +confirm-exempt+ - user confirmation of not being exempt, required in params
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +confirm-exempt+ - lack of the confirmation redirects back to {daily charge}[rdoc-ref:ChargesController.daily_charge]
  #
  def confirm_daily_charge
    form = ConfirmationForm.new(params['confirm-exempt'])
    if form.confirmed?
      redirect_to dates_charges_path
    else
      log_invalid_form 'Redirecting back to :daily_charge.'
      redirect_to daily_charge_charges_path, alert: I18n.t('confirmation_form.exemption')
    end
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

  # Takes right alert for the LA out of error object
  def la_alert(form)
    form.errors.messages[:authority].first
  end

  # Stores submitted LA in the session
  def store_la
    session[:la] = params['local-authority']
  end

  # Checks if LA is present in the session.
  # If not, redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  def check_la
    return if session[:la]

    Rails.logger.warn 'LA is missing in the session. Redirecting to :local_authority'
    redirect_to local_authority_charges_path
  end
end
