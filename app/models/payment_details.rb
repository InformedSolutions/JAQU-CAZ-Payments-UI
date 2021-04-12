# frozen_string_literal: true

##
# Class used to serialize the payment details on the success page
#
# ==== Usage
#
#    @payment_details = PaymentDetails.new(session[:vehicle_details])
#
class PaymentDetails
  ##
  # Initializer method
  #
  # ==== Params
  # * +session_details+ - hash
  #   * +external_id+ - payment ID in backend DB
  #   * +user_email+ - user email address
  #   * +reference_number+ - payment reference number
  #   * +vrn+ - vehicle registration number
  #   * +la_name+ - selected local authority name
  #   * +la_id+ - selected local authority ID
  #   * +dates+ - selected dates
  #   * +total_charge+ - total charge for selected dates
  #   * +chargeable_zones+ - number of zones in which the vehicle is chargeable
  #
  def initialize(session_details)
    @session_details = session_details
  end

  # Returns VRN, eg 'CU123A'
  def vrn
    session_details['vrn']
  end

  # Returns selected local authority name, eg. 'Bath'
  def la_name
    session_details['la_name']
  end

  # Returns user email address
  def user_email
    session_details['user_email']
  end

  # Returns the payment reference number
  def reference
    session_details['payment_reference']
  end

  # Returns the payment ID in backend DB
  def external_id
    session_details['external_id']
  end

  # Returns an array od dates
  def dates
    session_details['dates']
  end

  # Returns the total charge paid during the process
  def total_charge
    session_details['total_charge']
  end

  # Returns the number of available CAZ
  def chargeable_zones_count
    session_details['chargeable_zones']
  end

  # Returns an associated ComplianceDetails instance
  def compliance_details
    @compliance_details ||= if undetermined_taxi?
                              UnrecognisedComplianceDetails.new(la_id: la_id)
                            else
                              ComplianceDetails.new(session_details)
                            end
  end

  private

  # Reader function
  attr_reader :session_details

  # Returns info if payment is associated with undetermined taxi
  def undetermined_taxi?
    session_details['undetermined_taxi']
  end

  # Returns clean air zone id
  def la_id
    session_details['la_id']
  end
end
