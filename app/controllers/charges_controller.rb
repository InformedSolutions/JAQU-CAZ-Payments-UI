# frozen_string_literal: true

##
# Controls selecting LAs where the user wants to pay for.
#
class ChargesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn
  # checks if LA is present in the session
  before_action :check_compliance_details, except: %i[local_authority submit_local_authority]
  # checks if vehicle_details is present in the session
  before_action :check_vehicle_details, only: %i[review_payment]

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
    chargeable_zones = ChargeableZonesService.call(vehicle_details: session[:vehicle_details])
    return redirect_to compliant_vehicles_path if chargeable_zones.empty?

    @zones = chargeable_zones.map { |caz_data| Caz.new(caz_data) }
    @return_path = local_authority_return_path
  end

  ##
  # Validates and stores the selected local authority.
  # If successful, redirects to {picking dates}[rdoc-ref:DatesController.select_daily_date]
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
      store_compliance_details
      determinate_next_page
    else
      log_invalid_form 'Redirecting to :local_authority.'
      redirect_to local_authority_charges_path, alert: la_alert(form)
    end
  end

  ##
  # Renders a review payment page.
  #
  # ==== Path
  #    GET /charges/review_payment
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +dates+ - lack of dates redirects to {picking dates}[rdoc-ref:DatesController.select_daily_date]
  #
  def review_payment
    @vrn = vrn
    @la_name = la_name
    @dates = vehicle_details('dates')
    @weekly_period = vehicle_details('weekly')
    @total_charge = vehicle_details('total_charge')
    @return_path = review_payment_return_path
  end

  private

  # Takes right alert for the LA out of error object
  def la_alert(form)
    form.errors.messages[:authority].first
  end

  # Stores submitted LA in the session
  def store_compliance_details
    SessionManipulation::SetComplianceDetails.call(
      session: session,
      la_id: params['local-authority']
    )
  end

  # Define the back button path on local authority page.
  def local_authority_return_path
    if vehicle_details('incorrect')
      incorrect_details_vehicles_path
    elsif vehicle_details('country') == 'UK'
      details_vehicles_path
    else
      choose_type_non_dvla_vehicles_path
    end
  end

  # Define the back button path on review payment page.
  def review_payment_return_path
    if vehicle_details('weekly')
      weekly_charge_dates_path
    else
      daily_charge_dates_path
    end
  end

  # Returns redirect to selecting period if Leeds discounted charge is available.
  # Else, returns redirect to daily charge
  def determinate_next_page
    if vehicle_details('weekly_possible')
      redirect_to select_period_dates_path
    else
      redirect_to daily_charge_dates_path
    end
  end

  # Checks if vehicle_details is present in the session
  def check_vehicle_details
    return if la_id && la_name && vehicle_details('total_charge') && vehicle_details('dates')

    Rails.logger.warn 'Vehicle details is missing in the session. Redirecting to :enter_details'
    Rails.logger.warn "Current vehicle_details in session: #{session[:vehicle_details]}"
    redirect_to enter_details_vehicles_path
  end
end
