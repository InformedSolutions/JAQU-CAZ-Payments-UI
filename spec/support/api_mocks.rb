# frozen_string_literal: true

##
# Module used to stub API calls
#
module ApiMocks
  # Mocks data from the vehicle details endpoint in VCCS API
  def mock_vehicle_details
    vehicle_details = JSON.parse(file_fixture('vehicle_details_response.json').read)
    allow(ComplianceCheckerApi).to receive(:vehicle_details).and_return(vehicle_details)
  end
end
