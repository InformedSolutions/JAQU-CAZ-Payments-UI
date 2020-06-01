# frozen_string_literal: true

##
# Types to pick for non-DVLA vehicles
#
class VehicleTypes < BaseService
  ##
  # Returns a sorted array of available vehicle types.
  # Each type contains a display value - +:name+ and a API value - +:value+
  #
  # ==== Usage
  #    VehicleTypes.call
  #
  def call
    types.sort_by { |type| type[:name] }
  end

  private

  # Array of available types to choose.
  def types
    [
      { value: 'bus', name: 'Bus' },
      { value: 'coach', name: 'Coach' },
      { value: 'hgv', name: 'Heavy goods vehicle' },
      { value: 'van', name: 'Van' },
      { value: 'minibus', name: 'Minibus' },
      { value: 'private_car', name: 'Car' },
      { value: 'motorcycle', name: 'Motorcycle' }
    ]
  end
end
