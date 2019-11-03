# frozen_string_literal: true

##
# Controls the flow for calling Payments API.
#
class PaymentsController < ApplicationController
  before_action :check_payment_creation, only: :create
  before_action :check_payment_details, except: :create

  ##
  # The page used as a landing point after the GOV.UK payment process
  #
  # Calls +/payments/:id+ backend endpoint to get payment status
  #
  # Redirects to either success or failure payments path
  #
  # ==== Path
  #    GET /payments
  #
  # ==== Params
  # * +payment_id+ - vehicle registration number, required in the session
  #
  def index
    payment = PaymentStatus.new(vehicle_details('payment_id'))
    if payment.success?
      session[:vehicle_details]['user_email'] = payment.user_email
      redirect_to success_payments_path
    else
      redirect_to failure_payments_path
    end
  end

  ##
  # Creates a new payment from data stored in the session.
  # Sets in the session payment id returned from the backend.
  #
  # ==== Path
  #    POST /payments
  #
  # ==== Params
  # * +vrn+ - vehicle registration number, required in the session
  # * +la+ - selected local authority, required in the session
  # * +dates+ - selected dates, required in the session
  # * +daily_charge+ - daily charge for selected vehicle, required in the session
  #
  def create
    payment = Payment.new(session[:vehicle_details], payments_url)
    session[:vehicle_details]['payment_id'] = payment.payment_id
    redirect_to payment.gov_uk_pay_url
  end

  ##
  # Renders page after successful payment
  #
  # ==== Path
  #    GET /payments/success
  #
  # ==== Params
  # * +payment_id+ - vehicle registration number, required in the session
  # * +user_email+ - user email address, required in the session
  # * +vrn+ - vehicle registration number, required in the session
  # * +la_name+ - selected local authority, required in the session
  # * +dates+ - selected dates, required in the session
  # * +total_charge+ - total charge for selected dates, required in the session
  #
  def success
    @payment_id = vehicle_details('payment_id')
    @user_email = vehicle_details('user_email')
    @vrn = vrn
    @la_name = la_name
    @dates = vehicle_details('dates')
    @total_charge = vehicle_details('total_charge')
    clear_payment_in_session
  end

  ##
  # Renders page after unsuccessful payment
  #
  # ==== Path
  #    GET /payments/failure
  #
  # ==== Params
  # * +payment_id+ - vehicle registration number, required in the session
  #
  def failure
    @payment_id = vehicle_details('payment_id')
    clear_payment_in_session
  end

  private

  ##
  # Checks if payment id is present in the session
  #
  # If it is, redirects to payments index view
  #
  def check_payment_creation
    payment_id = vehicle_details('payment_id')
    return unless payment_id

    Rails.logger.warn "Payment with id: #{payment_id} was already created"
    redirect_to payments_path
  end

  def check_payment_details
    payment_id = vehicle_details('payment_id')
    return if payment_id

    Rails.logger.warn 'Payment id is missing'
    redirect_to enter_details_vehicles_path
  end

  def clear_payment_in_session
    payment_keys = %w[la la_name daily_charge dates total_charge payment_id user_email]
    session[:vehicle_details].except!(*payment_keys)
  end
end
