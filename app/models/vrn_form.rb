# frozen_string_literal: true

##
# This class is used to validate user data filled in +app/views/vehicle_checkers/enter_details.html.haml+.
class VrnForm
  # Submitted vehicle registration number
  attr_reader :vrn
  # Selected country value, possible values: 'UK', 'Non-UK'
  attr_reader :country
  # Hash containing validation errors
  attr_reader :error_object

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +vrn+ - string, eg. 'CU57ABC'
  # * +country+ - string, eg. 'UK'
  # * +error_object+ - empty hash, default error object
  def initialize(vrn, country)
    @vrn = vrn
    @country = country
    @error_object = {}
  end

  ##
  # Validate user data.
  #
  # Returns a boolean.
  def valid?
    if country == 'Non-UK'
      filled_vrn?
    else
      filled_vrn? && not_to_long? && not_to_short? && valid_format?
    end
    filled_country?
    error_object.empty?
  end

  private

  # Checks if at least one +vrn+ was selected.
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def filled_vrn?
    return true if vrn.present?

    vrn_error(I18n.t('vrn_form.vrn_missing'))
    false
  end

  # Checks if at least one +country+ was selected.
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def filled_country?
    return true if country.present?

    @error_object[:country] = {
      message: I18n.t('vrn_form.country_missing'),
      link: '#country-error'
    }
    false
  end

  # Checks if +vrn+ format is valid.
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def valid_format?
    return true if FORMAT_REGEXPS.any? do |reg|
      reg.match(vrn.gsub(/\s+/, '').upcase).present?
    end

    vrn_error(I18n.t('vrn_form.vrn_invalid'))
    false
  end

  # Checks if +vrn+ not to long.
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def not_to_long?
    return true if vrn.gsub(/\s+/, '').length <= 7

    vrn_error(I18n.t('vrn_form.vrn_too_long'))
    false
  end

  # Checks if +vrn+ not to short.
  #
  # If not, add error message to +error_object+.
  #
  # Returns a boolean.
  def not_to_short?
    return true if vrn.gsub(/\s+/, '').length > 1

    vrn_error(I18n.t('vrn_form.vrn_too_short'))
    false
  end

  # Add error message to +error_object+.
  #
  # ==== Attributes
  #
  # * +msg+ - string, eg. 'Enter the registration number of the vehicle'

  # ==== Result
  #
  # Returns +error_object+ as hash.
  def vrn_error(msg)
    @error_object[:vrn] = { message: msg, link: '#vrn-error' }
  end

  # Regexps formats to validate +vrn+.
  #
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
    /^[0-9]{4}[A-Z]{2}$/ # 9999AA
  ].freeze
end
