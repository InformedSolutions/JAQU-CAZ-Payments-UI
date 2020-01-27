# frozen_string_literal: true

##
# Controls selecting dates.
#
class DatesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn
  # checks if LA is present in the session
  before_action :check_compliance_details
  # checks if weekly Leeds discount is possible for weekly paths
  before_action :check_weekly, only: %i[select_period confirm_select_period
                                        weekly_charge confirm_weekly_charge
                                        select_weekly_date confirm_date_weekly]
  ##
  # Renders a select period page.
  #
  # ==== Path
  #    GET /charges/select_period
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def select_period
    # renders static page
  end

  ##
  # Validates if user selects at least one period.
  #
  # ==== Path
  #    POST /charges/confirm_select_period
  #
  # ==== Params
  # * +period+ - selected period
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +period+ - lack of the period redirects back to {select_period}[rdoc-ref:DatesController.select_period]
  #
  def confirm_select_period
    if params[:period]
      determinate_next_page
    else
      redirect_back_to(select_period_dates_path, true, :select_period)
    end
  end

  ##
  # Renders the charge value for a given LA and type of vehicle.
  #
  # ==== Path
  #    GET /charges/daily_charge
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def daily_charge
    @compliance_details = ComplianceDetails.new(session[:vehicle_details])
    @return_path = determinate_return_path
  end

  ##
  # Validates if user confirmed being not exempt for a given LA.
  # If yes, redirects to the {next step}[rdoc-ref:DatesController.select_daily_date]
  #
  # ==== Path
  #    POST /charges/confirm_daily_charge
  #
  # ==== Params
  # * +confirm-exempt+ - user confirmation of not being exempt, required in params
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-exempt+ - lack of the confirmation redirects back to {daily charge}[rdoc-ref:ChargesController.daily_charge]
  #
  def confirm_daily_charge
    form = ConfirmationForm.new(params['confirm-exempt'])
    if form.confirmed?
      redirect_to select_daily_date_dates_path
    else
      alert = I18n.t('confirmation_form.exemption')
      redirect_back_to(daily_charge_dates_path, alert, :daily_charge)
    end
  end

  ##
  # Renders the list of dates to pick. Already paid dates are marked as disabled.
  #
  # ==== Path
  #    GET /charges/select_daily_date
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def select_daily_date
    @local_authority = la_id
    @dates = Dates::Daily.call(vrn: vrn, zone_id: @local_authority)
  end

  ##
  # Validates if user selects at least one date and the dates were not paid before.
  #
  # ==== Path
  #    POST /dates/confirm_daily_date
  #
  # ==== Params
  # * +dates+ - selected dates
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +dates+ - lack of the date redirects back to {daily charge}[rdoc-ref:DatesController.select_daily_date]
  #
  def confirm_daily_date
    dates = params[:dates]
    if dates && check_already_paid(dates)
      SessionManipulation::CalculateTotalCharge.call(session: session, dates: params[:dates])
      redirect_to review_payment_charges_path
    else
      alert = I18n.t(dates ? 'paid' : 'empty', scope: 'dates.daily')
      redirect_back_to(select_daily_date_dates_path, alert, :dates)
    end
  end

  ##
  # Renders the weekly charge value for a given LA and type of vehicle.
  #
  # ==== Path
  #    GET /charges/weekly_charge
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def weekly_charge
    @compliance_details = ComplianceDetails.new(session[:vehicle_details])
    @weekly_charge = 50.00
    @return_path = determinate_return_path
  end

  ##
  # Validates if user confirmed being not exempt for a given LA.
  # If yes, redirects to the {next step}[rdoc-ref:DatesController.select_daily_date]
  #
  # ==== Path
  #    POST /charges/confirm_daily_charge
  #
  # ==== Params
  # * +confirm-exempt+ - user confirmation of not being exempt, required in params
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-exempt+ - lack of the confirmation redirects back to {daily charge}[rdoc-ref:DatesController.daily_charge]
  #
  def confirm_weekly_charge
    form = ConfirmationForm.new(params['confirm-exempt'])
    if form.confirmed?
      redirect_to select_weekly_date_dates_path
    else
      alert = I18n.t('confirmation_form.exemption')
      redirect_back_to(weekly_charge_dates_path, alert, :weekly_charge)
    end
  end

  ##
  # Renders the list of weekly dates to pick.
  #
  # ==== Path
  #    GET /dates/select_weekly_date
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def select_weekly_date
    @local_authority = la_id
    @dates = Dates::Weekly.call(vrn: vrn, zone_id: @local_authority)
  end

  ##
  # Validates if user selects at least one date.
  #
  # ==== Path
  #    POST /charges/confirm_date_weekly
  #
  # ==== Params
  # * +dates+ - selected dates
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +dates+ - lack of the date redirects back to {select_daily_date}[rdoc-ref:DatesController.select_daily_date]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def confirm_date_weekly
    if params[:dates]
      SessionManipulation::CalculateTotalCharge.call(
        session: session, dates: params[:dates], weekly: true
      )
      redirect_to review_payment_charges_path
    else
      redirect_back_to(select_weekly_date_dates_path, true, :dates)
    end
  end

  private

  ##
  # ==== Params
  # * +period+ - status for the vehicle type if it is not possible to determine, eg. 'true'

  # Verifies which date period was selected.
  # If date period equals 'daily-charge' redirects to {daily_charge}[rdoc-ref:DatesController.daily_charge]
  # If date period equals 'weekly-charge' redirects to {weekly_charge}[rdoc-ref:DatesController.weekly_charge]
  # If not equals 'daily-charge' or 'weekly-charge', redirects to {select_daily_date}[rdoc-ref:DatesController.select_daily_date]
  #
  def determinate_next_page
    if params[:period] == 'daily-charge'
      redirect_to daily_charge_dates_path
    elsif params[:period] == 'weekly-charge'
      redirect_to weekly_charge_dates_path
    else
      redirect_back_to(select_daily_date_dates_path, true, :dates)
    end
  end

  # Define the back button path on daily and weekly charge page.
  def determinate_return_path
    vehicle_details('taxi') ? select_period_dates_path : local_authority_charges_path
  end

  # Checks if weekly Leeds discount is possible
  def check_weekly
    return if vehicle_details('weekly_possible')

    Rails.logger.warn "Vehicle with VRN #{vrn} is not allowed for weekly Leeds discount"
    Rails.logger.warn "Current vehicle_details in session: #{session[:vehicle_details]}#"
    redirect_to daily_charge_dates_path
  end

  # Checks if given dates were not paid before. Returns boolean
  def check_already_paid(dates)
    Dates::CheckPaidDaily.call(vrn: vrn, zone_id: la_id, dates: dates)
  end
end
