# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Logs invalid form on +warn+ level
  def log_invalid_form(msg)
    Rails.logger.warn("The form is invalid. #{msg}")
  end
end
