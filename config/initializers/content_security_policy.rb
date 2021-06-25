# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

if Rails.env.production?
  defaults = %i[self https]
  defaults.push(ENV['CLOUDFRONT_ENDPOINT']) if ENV['CLOUDFRONT_ENDPOINT']
  style_src_hashes = "'sha256-X9p4TjH/YcVnBPLQowyqjpYeRftuKwrxa9Esue0lXSQ='", # cookieControl.js
                     "'sha256-2wbctP9QeeYIdN6tUTZfM2lRU20JjCKfxpcV0IqZTxU='", # cookieControl-9.1.min.js
                     "'sha256-0GYrWdLqt3hLu7QGjIxFZNP1rxLWoAENWtxQqPkNd4k='", # cookieControl-9.1.min.js
                     "'sha256-47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU='", # injectStylesIntoStyleTag.js
                     "'sha256-qSardLK1VNHG66LY67OhpH13yKcrUTLg8KmWNR8O3p0='", # injectStylesIntoStyleTag.js
                     "'sha256-8s9ypaWW7jRje3pVX1oZV65sLECS3gLRedmZI4gljko='", # injectStylesIntoStyleTag.js
                     "'sha256-/ZpOkDXPMNQcXQ8TCxzO+9D8CfB8AbzmCypo+t/6iHw='" # injectStylesIntoStyleTag.js

  Rails.application.config.content_security_policy do |policy|
    policy.default_src(:none)
    policy.font_src(*defaults, :data)
    policy.img_src(*defaults)
    policy.object_src(:none)
    policy.script_src(*defaults)
    policy.style_src(*defaults, *style_src_hashes)
    policy.connect_src(*defaults)
    policy.frame_src('https://www.googletagmanager.com')
    policy.frame_ancestors(:none)
  end
end

# If you are using UJS then enable automatic nonce generation
Rails.application.config.content_security_policy_nonce_generator =
  ->(_request) { SecureRandom.base64(16) }

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
