# frozen_string_literal: true

##
# Controls selecting LAs where the user wants to pay for.
#
class ChargesController < ApplicationController # rubocop:disable Metrics/ClassLength
  # 422 HTTP status from API means vehicle data incomplete so the compliance calculation is not possible.
  rescue_from BaseApi::Error422Exception, with: :unable_to_determine_compliance
  # checks if VRN is present in the session
  before_action :check_vrn
  # checks if LA is present in the session
  before_action :check_compliance_details, except: %i[local_authority submit_local_authority]
  # checks if vehicle_details is present in the session
  before_action :check_vehicle_details, only: %i[review_payment]
  # handle cancelling second week
  before_action :handle_second_week_cancel, only: %i[review_payment]

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
    @zones = ChargeableZonesService.call(vehicle_details: session[:vehicle_details])
    @all_chargeable_zones_displayed = all_chargeable_zones_displayed?(@zones)
    @undetermined = vehicle_details('undetermined')
    SessionManipulation::SetChargeableZones.call(
      session: session,
      chargeable_zones: @zones.length
    )
    return redirect_to compliant_vehicles_path(id: transaction_id) if @zones.empty?

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
    form = LocalAuthorityForm.new(local_authority_params)
    if form.valid?
      store_compliance_details
      determinate_next_page
    else
      redirect_to local_authority_charges_path(id: transaction_id), alert: la_alert(form)
    end
  end

  ##
  # Renders information about available discount in Bath CAZ.
  #
  # ==== Path
  #    GET /charges/discount_available
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +local-authority+ - selected local authority, required in session
  #
  # ==== Validations# ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +local-authority+ - lack of LA redirects back to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def discount_available
    @next_url = determinate_next_page_by_period
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
    @weekly_period = vehicle_details('weekly')
    @weekly_charge_today = vehicle_details('weekly_charge_today')
    @dates = vehicle_details('dates').sort
    @total_charge = vehicle_details('total_charge')
    @return_path = review_payment_return_path
    @chargeable_zones = vehicle_details('chargeable_zones')
    @transaction_id = transaction_id
    check_second_week_availability
  end

  private

  # Takes right alert for the LA out of error object
  def la_alert(form)
    form.errors.messages[:authority].first
  end

  # Stores submitted LA in the session
  def store_compliance_details
    if undetermined_taxi?
      SessionManipulation::SetUnrecognisedCompliance.call(session: session, la_id: local_authority_params)
    else
      SessionManipulation::SetComplianceDetails.call(session: session, la_id: local_authority_params)
    end
  end

  # Define the back button path on local authority page.
  def local_authority_return_path # rubocop:disable Metrics/MethodLength
    if vehicle_details('undetermined')
      not_determined_vehicles_path
    elsif vehicle_details('incorrect')
      incorrect_details_vehicles_path
    elsif vehicle_details('possible_fraud')
      uk_registered_details_vehicles_path
    elsif vehicle_details('country') == 'UK'
      details_vehicles_path
    else
      choose_type_non_dvla_vehicles_path # when vehicle is non-UK vehicle
    end
  end

  # Define the back button path on review payment page.
  def review_payment_return_path
    if return_to_second_week_selection
      select_second_weekly_date_dates_path
    elsif vehicle_details('weekly') && vehicle_details('confirm_weekly_charge_today')
      select_weekly_period_dates_path
    elsif vehicle_details('weekly')
      select_weekly_date_dates_path
    else
      select_daily_date_dates_path
    end
  end

  # Returns redirect to selecting period if weekly taxi discounted charge is available.
  # Else, redirect to disbount page if Bath phgv_discount is available
  # Else, returns redirect to daily charge
  def determinate_next_page
    return redirect_to determinate_next_page_by_period if undetermined_taxi?

    @compliance_details = ComplianceDetails.new(session[:vehicle_details])
    if la_name == 'Bath' && @compliance_details.phgv_discount_available?
      redirect_to discount_available_charges_path(id: transaction_id)
    else
      redirect_to determinate_next_page_by_period
    end
  end

  # Returns url to electing period if weekly taxi discounted charge is available.
  # Else, returns url daily charge
  def determinate_next_page_by_period
    if vehicle_details('weekly_possible')
      select_period_dates_path(id: transaction_id)
    else
      daily_charge_dates_path(id: transaction_id)
    end
  end

  # Checks if vehicle_details is present in the session
  def check_vehicle_details
    return if la_id && la_name && vehicle_details('total_charge') && vehicle_details('dates')

    Rails.logger.warn("Compliance details are missing. Current keys in session: #{session[:vehicle_details].keys}")
    redirect_to_enter_details('Vehicle details')
  end

  # Redirects to 'Unable to determine compliance' page
  def unable_to_determine_compliance
    SessionManipulation::SetUndetermined.call(session: session)
    redirect_to not_determined_vehicles_path(id: transaction_id)
  end

  # Checks if second week is available to be selected
  # If yes, sets the @second_week_available variable and overwrites the dates to display in a correct format
  def check_second_week_availability
    return unless @weekly_period

    Dates::AssignBackButtonDate.call(session: session)
    service = Dates::ReviewWeeklySelection.new(vrn: vrn, zone_id: la_id, session: session)
    @dates = service.format_week_selection
    @second_week_available = service.second_week_available?
  end

  # Specifies if back button should lead to second week selection page
  def return_to_second_week_selection
    vehicle_details('weekly') && session[:second_week_start_date] || cancel_second_week?
  end

  # Handles cancelling the second weekly selection
  def handle_second_week_cancel
    return unless cancel_second_week?

    session[:second_week_selected] = false
    SessionManipulation::CalculateTotalCharge.call(session: session,
                                                   dates: [session[:first_week_start_date]],
                                                   weekly: true)
  end

  # Indicates if adding a second week was just cancelled
  def cancel_second_week?
    params['cancel_second_week'] == 'true'
  end

  # Local authority from the query params
  def local_authority_params
    params['local-authority']
  end

  # Checks if chargeable zones for the vehicle are all current chargeable zones
  def all_chargeable_zones_displayed?(zones)
    zones.count == CazDataProvider.new.chargeable.count
  end
end
