# frozen_string_literal: true

##
# Controls the flow for calling Payments API.
#
class PaymentsController < ApplicationController
  before_action :check_payment_id, only: :create

  def index
    @payment_id = vehicle_details('payment_id')
    redirect_to confirm_payment_payments_path
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
    session[:vehicle_details]['payment_id'] = 'XYZ123ABC'
    session[:vehicle_details]['user_email'] = 'example@email.com'
    redirect_to confirm_payment_payments_path

    # payment = Payment.new(session[:vehicle_details], payments_url)
    # session[:vehicle_details]['payment_id'] = payment.payment_id
    # redirect_to payment.gov_uk_pay_url
  end

  ##
  # Renders page after successful payment
  #
  # ==== Path
  #    GET /confirm_payment
  #
  # ==== Params
  # * +payment_id+ - vehicle registration number, required in the session
  # * +user_email+ - user email address, required in the session
  # * +vrn+ - vehicle registration number, required in the session
  # * +la_name+ - selected local authority, required in the session
  # * +dates+ - selected dates, required in the session
  # * +total_charge+ - total charge for selected dates, required in the session
  #
  def confirm_payment
    @payment_id = session[:vehicle_details]['payment_id']
    @user_email = session[:vehicle_details]['user_email']
    @vrn = vrn
    @la_name = vehicle_details('la_name')
    @dates = vehicle_details('dates')
    @total_charge = vehicle_details('total_charge')
  end

  private

  ##
  # Checks if payment id is present in the session
  #
  # If it is, redirects to payments index view
  #
  def check_payment_id
    payment_id = vehicle_details('payment_id')
    return unless payment_id

    Rails.logger.warn "Payment with id: #{payment_id} was already created"
    redirect_to payments_path
  end
end
