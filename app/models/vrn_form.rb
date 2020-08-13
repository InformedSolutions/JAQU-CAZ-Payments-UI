# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicles/enter_details.html.haml+.
#
class VrnForm # rubocop:disable Metrics/ClassLength
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
    @vrn = vrn&.delete(' ')&.upcase
    @country = country
  end

  # Persists vehicle details into session and returns correct onward path
  def submit
    SessionManipulation::AddVrn.call(session: session, vrn: vrn, country: country)

    if uk?
      @redirection_path = details_vehicles_path
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
      reg.match(vrn).present?
    end && no_leading_zeros?
  end

  # Checks if VRN starts with '0'
  def no_leading_zeros?
    !vrn.starts_with?('0')
  end

  # Check if VRN is DVLA registered
  def dvla_registered?
    ComplianceCheckerApi.vehicle_details(vrn)
    true
  rescue BaseApi::Error404Exception
    false
  end

  # Process non UK selected VRN
  def process_non_uk
    if match_uk_format? && dvla_registered?
      SessionManipulation::AddVrn.call(session: session, vrn: vrn, country: 'UK')
      SessionManipulation::SetPossibleFraud.call(session: session)
      @redirection_path = uk_registered_details_vehicles_path
    else
      @redirection_path = non_dvla_vehicles_path
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
    /^[A-Z]{3}[0-9]{3}$/, # AAA999
    /^[A-Z][0-9]{3}[A-Z]{3}$/, # A999AAA
    /^[A-Z]{3}[0-9]{3}[A-Z]$/, # AAA999A
    /^[A-Z]{3}[0-9]{4}$/, # AAA9999
    /^[A-Z]{2}[0-9]{2}[A-Z]{3}$/, # AA99AAA
    /^[0-9]{4}[A-Z]{3}$/, # 9999AAA
    /^[A-Z][0-9]$/, # A9
    /^[0-9][A-Z]$/, # 9A
    /^[A-Z]{2}[0-9]$/, # AA9
    /^[A-Z][0-9]{2}$/, # A99
    /^[0-9][A-Z]{2}$/, # 9AA
    /^[0-9]{2}[A-Z]$/, # 99A
    /^[A-Z]{3}[0-9]$/, # AAA9
    /^[A-Z][0-9]{3}$/, # A999
    /^[A-Z]{2}[0-9]{2}$/, # AA99
    /^[0-9][A-Z]{3}$/, # 9AAA
    /^[0-9]{2}[A-Z]{2}$/, # 99AA
    /^[0-9]{3}[A-Z]$/, # 999A
    /^[A-Z][0-9][A-Z]{3}$/, # A9AAA
    /^[A-Z]{3}[0-9][A-Z]$/, # AAA9A
    /^[A-Z]{3}[0-9]{2}$/, # AAA99
    /^[A-Z]{2}[0-9]{3}$/, # AA999
    /^[0-9]{2}[A-Z]{3}$/, # 99AAA
    /^[0-9]{3}[A-Z]{2}$/, # 999AA
    /^[0-9]{4}[A-Z]$/, # 9999A
    /^[A-Z][0-9]{4}$/, # A9999
    /^[A-Z][0-9]{2}[A-Z]{3}$/, # A99AAA
    /^[A-Z]{3}[0-9]{2}[A-Z]$/, # AAA99A
    /^[0-9]{3}[A-Z]{3}$/, # 999AAA
    /^[A-Z]{2}[0-9]{4}$/, # AA9999
    /^[0-9]{4}[A-Z]{2}$/, # 9999AA

    # The following regex is technically not valid, but is considered as valid
    # due to the requirement which forces users not to include leading zeros.
    /^[A-Z]{2,3}$/ # AA, AAA
  ].freeze
end
