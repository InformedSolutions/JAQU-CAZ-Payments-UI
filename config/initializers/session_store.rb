# frozen_string_literal: true

store_type = ENV['REDIS_URL'] && !Rails.env.test? ? :cache_store : :cookie_store
Rails.application.config.session_store store_type,
                                       key: '_caz_payments_session',
                                       # Allow to only send the cookie in a first-party context.
                                       # Meaning to be able to load session after redirect from GOV.UK Pay
                                       same_site: :lax,
                                       secure: Rails.env.production?
