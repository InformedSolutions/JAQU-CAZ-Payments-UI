# frozen_string_literal: true

RSpec.shared_examples 'a chargeable zones service' do |size = 2|
  it 'returns a list of Caz' do
    expect(service_call).to all(be_a(Caz))
  end

  it "returns #{size} Caz objects" do
    expect(service_call.length).to eq(size)
  end

  it 'sets name in Caz objects' do
    expect(service_call.map(&:name)).to all(be_a(String))
  end

  it 'calls ComplianceCheckerApi.clean_air_zones' do
    expect(ComplianceCheckerApi).to receive(:clean_air_zones)
    service_call
  end
end
