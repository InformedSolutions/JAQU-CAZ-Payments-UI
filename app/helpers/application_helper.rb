# frozen_string_literal: true

module ApplicationHelper
  def service_name
    Rails.configuration.x.service_name
  end
end
