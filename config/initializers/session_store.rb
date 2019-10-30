# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                       key: '_caz-payments_session',
                                       # Replace SameSite policy to be able to load session after redirect from GOV.UK Pay
                                       same_site: :lax # :strict
