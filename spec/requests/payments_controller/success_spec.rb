# frozen_string_literal: true

require 'rails_helper'

describe 'PaymentsController - GET #success', type: :request do
  subject { get success_payments_path }

  let(:vrn) { 'CU57ABC' }
  let(:zone_id) { SecureRandom.uuid }
  let(:dates) { [Date.current, Date.tomorrow].map(&:to_s) }
  let(:charge) { 10 }
  let(:payment_id) { 'XYZ123ABC' }
  let(:user_email) { 'user_email@example.com' }
  let(:url) { 'www.wp.pl' }

  before do
    add_vehicle_details_to_session(
      vrn: vrn,
      payment_id: payment_id,
      user_email: user_email,
      la_name: 'Taxidiscountcaz',
      dates: dates,
      total_charge: charge,
      chargeable_zones: 2,
      payment_reference: 1,
      external_id: 'external id'
    )
    allow(ComplianceDetails)
      .to receive(:new)
      .and_return(instance_double(ComplianceDetails,
                                  public_transport_options_url: url,
                                  additional_compliance_url: url,
                                  dynamic_compliance_url: url))
    subject
  end

  it 'returns http success' do
    expect(response).to have_http_status(:success)
  end

  it 'does not clear other details in session' do
    expect(session[:vehicle_details]['vrn']).to eq(vrn)
  end
end
