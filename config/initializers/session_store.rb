# frozen_string_literal: true

Rails.application.config.session_store :disabled

# The same_site cookie attribute is a great help against cross site request forgery
# https://medium.com/compass-security/samesite-cookie-attribute-33b3bfeaeb95
# Rails.application.config.session_store :cookie_store,
#                                        key: '_id_session',
#                                        same_site: :strict
