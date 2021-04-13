# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicles/enter_details.html.haml+.
#
class VrnForm
  include ActiveModel::Validations
  include Rails.application.routes.url_helpers

  # VRN, country and redirection_path getters
  attr_reader :vrn, :country, :redirection_path

  # Checks if country is selected and UK or Non-UK
  validates :country, inclusion: {
    in: %w[UK Non-UK], message: I18n.t('vrn_form.country_missing')
  }
  # Check if VRN is present
  validates :vrn, presence: { message: I18n.t('vrn_form.vrn_missing') }
  # Checks if VRN has valid length when vehicle is registered in the UK
  validates :vrn, length: {
    minimum: 2, too_short: I18n.t('vrn_form.vrn_too_short'),
    maximum: 7, too_long: I18n.t('vrn_form.vrn_too_long')
  }, if: -> { uk? }
  # Checks if VRN is in valid format when vehicle is registered in the UK
  validate :vrn_uk_format, if: -> { uk? }
  # Checks if VRN contains only alphanumerics when vehicle is not registered in the UK
  validate :vrn_non_uk_format, if: -> { non_uk? }

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +session+ - the user's session
  # * +vrn+ - string, eg. 'CU57ABC'
  # * +country+ - string, eg. 'UK'
  #
  def initialize(session, vrn, country)
    @session = session
    @vrn = vrn&.gsub(/\t+|\s+/, '')&.upcase
    @country = country
  end

  # Persists vehicle details into session and returns correct onward path
  def submit
    if uk?
      SessionManipulation::AddVrn.call(session: session, vrn: vrn, country: country)
      @redirection_path = details_vehicles_path(id: session[:transaction_id])
    elsif non_uk?
      process_non_uk
    end
  end

  private

  attr_reader :session

  # Checks if selected country is UK. Returns boolean.
  def uk?
    country == 'UK'
  end

  # Check if select country is Non-UK. Returns boolean.
  def non_uk?
    country == 'Non-UK'
  end

  # Check if VRN match uk format
  def match_uk_format?
    FORMAT_REGEXPS.any? do |reg|
      reg.match(vrn_without_leading_zeros).present?
    end
  end

  # Returns VRN with leading zeros stripped
  def vrn_without_leading_zeros
    @vrn_without_leading_zeros ||= vrn.gsub(/^0+/, '')
  end

  # Check if VRN is DVLA registered
  def dvla_registered?
    ComplianceCheckerApi.vehicle_details(vrn_without_leading_zeros)
    true
  rescue BaseApi::Error404Exception
    false
  end

  # Process non UK selected VRN
  def process_non_uk
    if match_uk_format? && dvla_registered?
      SessionManipulation::AddVrn.call(session: session, vrn: vrn_without_leading_zeros,
                                       country: 'UK') && set_possible_fraud
      @redirection_path = uk_registered_details_vehicles_path(id: session[:transaction_id])
    else
      SessionManipulation::AddVrn.call(session: session, vrn: vrn_without_leading_zeros, country: country)
      @redirection_path = non_dvla_vehicles_path(id: session[:transaction_id])
    end
  end

  # Checks if VRN matches any possible VRN format
  def vrn_uk_format
    return if match_uk_format?

    add_format_error
  end

  # Checks if VRN contains only alphanumerics
  def vrn_non_uk_format
    return if /^[A-Za-z0-9]+$/.match(vrn).present?

    add_format_error
  end

  # Adds format error
  def add_format_error
    errors.add(:vrn, I18n.t('vrn_form.vrn_invalid'))
  end

  # Regexps formats to validate +vrn+.
  FORMAT_REGEXPS = [
    /^[A-Za-z]{1,2}[0-9]{1,4}$/,
    /^[A-Za-z]{3}[0-9]{1,3}$/,
    /^[1-9][0-9]{0,2}[A-Za-z]{3}$/,
    /^[1-9][0-9]{0,3}[A-Za-z]{1,2}$/,
    /^[A-Za-z]{3}[0-9]{1,3}[A-Za-z]$/,
    /^[A-Za-z][0-9]{1,3}[A-Za-z]{3}$/,
    /^[A-Za-z]{2}[0-9]{2}[A-Za-z]{3}$/,
    /^[A-Za-z]{3}[0-9]{4}$/,

    # The following regex is technically not valid, but is considered as valid
    # due to the requirement which forces users not to include leading zeros.
    /^[A-Z]{2,3}$/ # AA, AAA
  ].freeze

  # Service used to mark vehicle as possible fraud.
  def set_possible_fraud
    SessionManipulation::SetPossibleFraud.call(session: session)
  end
end
