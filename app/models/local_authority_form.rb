# frozen_string_literal: true

##
# This class is used to validate charge data filled in +app/views/charges/local_authority.html.haml+.
#
class LocalAuthorityForm
  include ActiveModel::Validations

  validates :authority, presence: { message: I18n.t('la_form.la_missing') }

  ##
  # Initializer method
  #
  # ==== Attributes
  #
  # * +authority+ - string, eg. 'Leeds'
  #
  def initialize(authority)
    @authority = authority
  end

  private

  attr_reader :authority
end
