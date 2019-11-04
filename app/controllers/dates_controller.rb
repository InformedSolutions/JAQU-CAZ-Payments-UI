# frozen_string_literal: true

##
# Controls selecting dates.
#
class DatesController < ApplicationController
  # checks if VRN is present in the session
  before_action :check_vrn
  # checks if LA is present in the session
  before_action :check_la_id
  # checks if LA name is present in the session
  before_action :check_la_name, only: %i[confirm_daily_charge select_daily_date
                                         confirm_daily_date
                                         confirm_weekly_charge select_weekly_date
                                         confirm_date_weekly]
  # checks if charge is present in the session
  before_action :check_charge, only: %i[confirm_daily_charge select_daily_date
                                        confirm_daily_date confirm_weekly_charge
                                        select_weekly_date
                                        confirm_date_weekly]

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
      log_invalid_form 'Redirecting back to :select_period.'
      redirect_to select_period_charges_path, alert: true
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
    session[:vehicle_details][:charge] = @compliance_details.charge
    session[:vehicle_details][:la_name] = @compliance_details.zone_name
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
      session[:vehicle_details]['weekly_period'] = false
      redirect_to select_daily_date_charges_path
    else
      log_invalid_form 'Redirecting back to :daily_charge.'
      redirect_to daily_charge_charges_path, alert: I18n.t('confirmation_form.exemption')
    end
  end

  ##
  # Renders the list of dates to pick.
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
    @dates = Dates::Daily.call
  end

  ##
  # Validates if user selects at least one date.
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
    if params[:dates]
      session[:vehicle_details]['dates'] = params[:dates]
      redirect_to review_payment_charges_path
    else
      log_invalid_form 'Redirecting back to :dates.'
      redirect_to select_daily_date_charges_path, alert: true
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
    session[:vehicle_details]['charge'] = @weekly_charge
    session[:vehicle_details]['la_name'] = @compliance_details.zone_name
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
      session[:vehicle_details]['weekly_period'] = true
      redirect_to select_weekly_date_charges_path
    else
      log_invalid_form 'Redirecting back to :weekly_charge.'
      redirect_to weekly_charge_charges_path, alert: I18n.t('confirmation_form.exemption')
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
    @dates = Dates::Weekly.call
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
      session[:vehicle_details]['dates'] = params[:dates]
      redirect_to review_payment_charges_path
    else
      log_invalid_form 'Redirecting back to :dates.'
      redirect_to select_weekly_date_charges_path, alert: true
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
      redirect_to daily_charge_charges_path
    elsif params[:period] == 'weekly-charge'
      redirect_to weekly_charge_charges_path
    else
      log_invalid_form 'Redirecting back to :dates.'
      redirect_to select_daily_date_charges_path, alert: true
    end
  end

  # Define the back button path on daily and weekly charge page.
  def determinate_return_path
    vehicle_details('taxi') ? select_period_charges_path : local_authority_charges_path
  end
end
