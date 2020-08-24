# frozen_string_literal: true

##
# Controls selecting dates.
#
class DatesController < ApplicationController # rubocop:disable Metrics/ClassLength
  # checks if VRN is present in the session
  before_action :check_vrn
  # checks if LA is present in the session
  before_action :check_compliance_details
  # checks if weekly Leeds discount is possible for weekly paths
  before_action :check_weekly, only: %i[select_period confirm_select_period weekly_charge
                                        confirm_weekly_charge select_weekly_date select_second_weekly_date
                                        confirm_date_weekly select_weekly_period confirm_select_weekly_period]
  # checks if weekly discount is possible to pay for today
  before_action :check_weekly_charge_today, only: %i[select_weekly_period confirm_select_weekly_period]
  # fetching +active_charge_start_date+ and assigns it to the variable
  before_action :assign_charge_start_date, only: %i[select_weekly_date select_second_weekly_date
                                                    confirm_date_weekly]

  # resets which weeks was selected
  before_action :reset_week_selection, only: %i[select_weekly_date determinate_next_weekly_page]

  ##
  # Renders a select period page.
  #
  # ==== Path
  #    GET /dates/select_period
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def select_period
    @return_path = if params['second_week'] == 'false'
                     select_weekly_date_dates_path
                   elsif params['second_week'] == 'true'
                     select_second_weekly_date_dates_path
                   else
                     local_authority_charges_path
                   end
  end

  ##
  # Validates if user selects at least one period.
  #
  # ==== Path
  #    POST /dates/confirm_select_period
  #
  # ==== Params
  # * +period+ - selected period
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +period+ - lack of the period redirects back to {select_period}[rdoc-ref:select_period]
  #
  def confirm_select_period
    if params[:period]
      SessionManipulation::SetChargePeriod.call(session: session, charge_period: params[:period])
      determinate_next_page
    else
      redirect_back_to(select_period_dates_path, true, :select_period)
    end
  end

  ##
  # Renders the charge value for a given LA and type of vehicle.
  #
  # ==== Path
  #    GET /dates/daily_charge
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
  # If yes, redirects to the {next step}[rdoc-ref:select_daily_date]
  #
  # ==== Path
  #    POST /dates/confirm_daily_charge
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
    if form.valid?
      SessionManipulation::SetConfirmExempt.call(session: session)
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
  #    GET /dates/select_daily_date
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def select_daily_date
    @charge_start_date = FetchSingleCazData.call(zone_id: la_id)&.active_charge_start_date
    service = Dates::Daily.new(vrn: vrn, zone_id: la_id, charge_start_date: @charge_start_date)
    @dates = service.chargeable_dates
    @d_day_notice = service.d_day_notice
    @all_paid = @dates.all? { |date| date[:disabled] }
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
  # * +dates+ - lack of the date redirects back to {daily charge}[rdoc-ref:select_daily_date]
  #
  def confirm_daily_date
    dates = params[:dates]
    if dates && check_already_paid(dates)
      SessionManipulation::CalculateTotalCharge.call(session: session, dates: dates)
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
  #    GET /dates/weekly_charge
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  #
  def weekly_charge
    Dates::AssignBackButtonDate.call(session: session)
    @compliance_details = ComplianceDetails.new(session[:vehicle_details])
    @weekly_charge = 50.00
    @return_path = determinate_return_path
  end

  ##
  # Validates if user confirmed being not exempt for a given LA.
  # If yes, redirects to the {next step}[rdoc-ref:select_daily_date]
  #
  # ==== Path
  #    POST /dates/confirm_daily_charge
  #
  # ==== Params
  # * +confirm-exempt+ - user confirmation of not being exempt, required in params
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +confirm-exempt+ - lack of the confirmation redirects back to {daily charge}[rdoc-ref:daily_charge]
  #
  def confirm_weekly_charge
    form = ConfirmationForm.new(params['confirm-exempt'])
    if form.confirmed?
      SessionManipulation::SetConfirmExempt.call(session: session)
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
    handle_back_action(second_week_selected: false,
                       session_date: week_start_days.first,
                       back_button_date: back_button_week_dates.first)

    @return_path = select_weekly_date_return_path
    handle_select_weekly_date
  end

  ##
  # Renders the list of weekly dates to pick as a second week.
  #
  # ==== Path
  #    GET /dates/select_second_weekly_date
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def select_second_weekly_date
    handle_back_action(second_week_selected: true,
                       session_date: week_start_days.second,
                       back_button_date: back_button_week_dates.second)

    SessionManipulation::SetSelectedWeek.call(session: session, second_week_selected: true)
    handle_select_weekly_date
  end

  ##
  # Validates if user selects at least one date and there was no payment for any date in the given time-frame.
  #
  # ==== Path
  #    POST /dates/confirm_date_weekly
  #
  # ==== Params
  # * +date-day+ - selected day
  # * +date-month+ - selected month
  # * +date-year+ - selected year
  #
  # ==== Validations
  # * +vrn+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +la_id+ - lack of LA redirects to {picking LA}[rdoc-ref:ChargesController.local_authority]
  # * +dates+ - lack of the date redirects back to {select_daily_date}[rdoc-ref:select_daily_date]
  # * +la_name+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  # * +charge+ - lack of VRN redirects to {enter_details}[rdoc-ref:VehiclesController.enter_details]
  #
  def confirm_date_weekly
    service = Dates::ValidateSelectedWeeklyDate.new(params: params,
                                                    charge_start_date: @charge_start_date,
                                                    session: session)

    if service.valid? && check_already_paid_weekly([service.start_date])
      Dates::AssignBackButtonDate.call(session: session)
      service.add_dates_to_session
      redirect_to review_payment_charges_path
    else
      redirect_back_to(determinate_week_select_redirect_path, service.error, :dates)
    end
  end

  ##
  # Renders today or another day selection page
  #
  # ==== Path
  #    GET /dates/select_weekly_period
  #
  # ==== Validations
  # * +weekly_charge_today+ - lack of value in the session redirects to {weekly_charge}[rdoc-ref:weekly_charge]
  #
  def select_weekly_period
    @return_path = if week_start_days.first
                     review_payment_charges_path
                   else
                     weekly_charge_dates_path
                   end
  end

  ##
  # Validates if user selects at least one charge period
  #
  # ==== Path
  #    POST /dates/select_weekly_date
  #
  def confirm_select_weekly_period
    if params[:confirm_weekly_charge_today]
      Dates::AssignBackButtonDate.call(session: session)
      determinate_next_weekly_page
    else
      flash.now[:alert] = I18n.t('select_weekly_period')
      render :select_weekly_period
    end
  end

  private

  ##
  # Validates weekly dates and assigns variables used in views
  def handle_select_weekly_date
    service = Dates::Weekly.new(vrn: vrn, zone_id: la_id, second_week_selected: second_week_selected?,
                                charge_start_date: @charge_start_date, week_start_days: week_start_days)

    check_if_pay_week_starts_today(service) unless second_week_selected?

    @dates = service.chargeable_dates
    @d_day_notice = service.d_day_notice
    @all_paid = @dates.all? { |date| date[:disabled] }
  end

  # Checks if pay week starts today
  # If yes, redirects to select_weekly_period page
  def check_if_pay_week_starts_today(service)
    if service.pay_week_starts_today? && vehicle_details('confirm_weekly_charge_today') != false
      add_weekly_charge_today_to_session(service.today_date)
      redirect_to select_weekly_period_dates_path
    end
  end

  # Determinates redirect path after invalid date selected
  def determinate_week_select_redirect_path
    if !second_week_selected?
      select_weekly_date_dates_path
    else
      select_second_weekly_date_dates_path
    end
  end

  ##
  # ==== Params
  # * +period+ - status for the vehicle type if it is not possible to determine, eg. 'true'

  # Verifies which date period was selected.
  # If date period equals 'daily-charge' redirects to {daily_charge}[rdoc-ref:daily_charge]
  # If date period equals 'weekly-charge' redirects to {weekly_charge}[rdoc-ref:weekly_charge]
  # If not equals 'daily-charge' or 'weekly-charge', redirects to {select_daily_date}[rdoc-ref:select_daily_date]
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
    la_name == 'Leeds' && weekly_possible ? select_period_dates_path : local_authority_charges_path
  end

  # Checks if weekly discount is possible
  def check_weekly
    return if vehicle_details('weekly_possible')

    Rails.logger.warn('Vehicle is not allowed for weekly discount')
    redirect_to daily_charge_dates_path
  end

  # Checks if weekly discount is possible to pay for today
  def check_weekly_charge_today
    return unless vehicle_details('weekly_charge_today').nil?

    Rails.logger.warn('Vehicle is not allowed to pay weekly discount for today')
    redirect_to daily_charge_dates_path
  end

  # Checks if given dates were not paid before. Returns boolean
  def check_already_paid(dates)
    Dates::CheckPaidDaily.call(vrn: vrn, zone_id: la_id, dates: dates)
  end

  # Checks if given time-frame were not paid before. Returns boolean
  def check_already_paid_weekly(dates)
    Dates::CheckPaidWeekly.call(vrn: vrn, zone_id: la_id, date: dates.first)
  end

  # Fetching +active_charge_start_date+ and assigns it to variable
  def assign_charge_start_date
    @charge_start_date = FetchSingleCazData.call(zone_id: la_id)&.active_charge_start_date
  end

  # Sets +dates_to_disable+ and +weekly_charge_today+ to the session
  def add_weekly_charge_today_to_session(today_date)
    SessionManipulation::SetWeeklyChargeToday.call(
      session: session,
      weekly_charge_today: true,
      today: [today_date]
    )
  end

  # Verifies which weekly charge period was selected, adding calculated the total charge for the payment
  # based on selected period or adding +weekly_charge_today+ to the session and redirects to the proper page
  #
  def determinate_next_weekly_page
    add_confirm_charge_today_to_session
    if params[:confirm_weekly_charge_today] == 'true'
      SessionManipulation::SetSelectedWeek.call(session: session, second_week_selected: false)
      SessionManipulation::CalculateTotalCharge.call(session: session, weekly: true)
      redirect_to review_payment_charges_path
    else
      redirect_to select_weekly_date_dates_path
    end
  end

  # Sets +confirm_weekly_charge_today+ to the session
  def add_confirm_charge_today_to_session
    SessionManipulation::SetConfirmWeeklyChargeToday.call(
      session: session,
      confirm_weekly_charge_today: (params[:confirm_weekly_charge_today] == 'true')
    )
  end

  # Determinate back path on select weekly date page
  def select_weekly_date_return_path
    if params[:change] == 'true'
      review_payment_charges_path
    else
      vehicle_details('weekly_charge_today') ? select_weekly_period_dates_path : weekly_charge_dates_path
    end
  end

  # Returns array of selected week dates for weekly selection
  def week_start_days
    [session[:first_week_start_date], session[:second_week_start_date]].compact
  end

  # Returns array of held selected week dates used for back button process
  def back_button_week_dates
    [session[:first_week_back_button], session[:second_week_back_button]]
  end

  # Clears session second_week_selected key
  def reset_week_selection
    SessionManipulation::SetSelectedWeek.call(session: session, second_week_selected: nil)
  end

  # Returns session second_week_selected key
  def second_week_selected?
    session[:second_week_selected]
  end

  # Handles case when first or second week Leeds taxi is redirected to due to back button click
  # Sets correct value to date input
  def handle_back_action(second_week_selected:, session_date:, back_button_date:)
    return if params[:change] == 'true'

    if session_date && review_as_last_path
      @input_date = Date.parse(session_date)
      Dates::AssignBackButtonDate.call(session: session, second_week_selected: second_week_selected)
    elsif use_back_button_date(second_week_selected: second_week_selected, back_button_date: back_button_date)
      @input_date = Date.parse(back_button_date)
    end
  end

  # Specifies if back button date should be used
  # Returns boolean
  def use_back_button_date(second_week_selected:, back_button_date:)
    (!second_week_selected && back_button_date) ||
      (second_week_selected && back_button_date && !review_as_last_path)
  end

  # Specifies if the page before was Review payment page
  # Returns boolean
  def review_as_last_path
    request&.referer&.include?(review_payment_charges_path)
  end
end
