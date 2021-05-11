# frozen_string_literal: true

require 'rails_helper'

describe ComplianceDetails, type: :model do
  subject(:details) { described_class.new(vehicle_details) }

  let(:vehicle_details) do
    {
      'vrn' => vrn,
      'country' => country,
      'la_id' => zone_id,
      'unrecognised' => unrecognised,
      'dvla_vehicle_type' => dvla_vehicle_type,
      'type' => type
    }
  end

  let(:vrn) { 'CU57ABC' }
  let(:country) { 'UK' }
  let(:zone_id) { SecureRandom.uuid }
  let(:unrecognised) { false }
  let(:type) { 'bus' }
  let(:tariff) { 'BCC01-BUS' }
  let(:charge) { 15 }
  let(:dvla_vehicle_type) { nil }

  let(:outcomes) do
    [
      {
        'name' => name,
        'charge' => charge,
        'tariffCode' => tariff,
        'informationUrls' => {
          'exemptionOrDiscount' => url,
          'becomeCompliant' => url,
          'mainInfo' => url,
          'publicTransportOptions' => url,
          'paymentsCompliance' => url,
          'fleetsCompliance' => url
        }
      }
    ]
  end
  let(:phgv_discount_available) { true }
  let(:name) { 'Taxidiscountcaz' }
  let(:url) { 'https://www.brumbreathes.co.uk/homepage/7/financial-incentives' }

  let(:unrecognised_response) do
    {
      'charges' =>
      [
        {
          'cleanAirZoneId' => '39e54ed8-3ed2-441d-be3f-38fc9b70c8d3',
          'name' => name,
          'tariffCode' => tariff,
          'charge' => charge
        }
      ]
    }
  end

  context 'when the vehicle is registered in the UK' do
    before do
      allow(ComplianceCheckerApi)
        .to receive(:vehicle_compliance)
        .with(vrn, [zone_id])
        .and_return('complianceOutcomes' => outcomes,
                    'phgvDiscountAvailable' => phgv_discount_available)
    end

    it 'calls :vehicle_compliance with right params' do
      details.zone_name
      expect(ComplianceCheckerApi).to have_received(:vehicle_compliance).with(vrn, [zone_id])
    end

    it_behaves_like 'compliance details fields'

    describe 'urls' do
      %i[exemption_or_discount_url
         compliance_url
         main_info_url
         public_transport_options_url].each do |method|
        describe ".#{method}" do
          it 'returns URL' do
            expect(details.public_send(method)).to eq(url)
          end
        end
      end

      describe 'phgv_discount_available?' do
        context 'when phgvDiscountAvailable is true in compliance endpoint' do
          it 'returns true' do
            expect(details).to be_phgv_discount_available
          end
        end

        context 'when phgvDiscountAvailable is false in compliance endpoint' do
          let(:phgv_discount_available) { false }

          it 'returns true' do
            expect(details).not_to be_phgv_discount_available
          end
        end
      end
    end

    context 'when vehicle is unrecognised but has type in DVLA' do
      let(:unrecognised) { true }
      let(:dvla_vehicle_type) { 'Heavy goods vehicle' }
      let(:type) { nil }
      let(:mapped_dvla_vehicle_type) { 'hgv' }

      before do
        allow(ComplianceCheckerApi)
          .to receive(:unrecognised_compliance)
          .with(mapped_dvla_vehicle_type, [zone_id])
          .and_return(unrecognised_response)
      end

      it 'calls :unrecognised_compliance with right params' do
        details.zone_name
        expect(ComplianceCheckerApi).to(
          have_received(:unrecognised_compliance).with(mapped_dvla_vehicle_type, [zone_id])
        )
      end

      it 'does not call :vehicle_compliance' do
        details.zone_name
        expect(ComplianceCheckerApi).not_to have_received(:vehicle_compliance)
      end

      it_behaves_like 'compliance details fields'
    end

    context 'when vehicle is unrecognised but has chosen type during the process' do
      let(:unrecognised) { true }

      before do
        allow(ComplianceCheckerApi)
          .to receive(:unrecognised_compliance)
          .with(type, [zone_id])
          .and_return(unrecognised_response)
      end

      it 'calls :unrecognised_compliance with right params' do
        details.zone_name
        expect(ComplianceCheckerApi).to(
          have_received(:unrecognised_compliance).with(type, [zone_id])
        )
      end

      it 'does not call :vehicle_compliance' do
        details.zone_name
        expect(ComplianceCheckerApi).not_to have_received(:vehicle_compliance)
      end

      it_behaves_like 'compliance details fields'
    end
  end

  context 'when the vehicle is registered outside of the UK' do
    let(:country) { 'non-UK' }

    before do
      allow(ComplianceCheckerApi)
        .to receive(:unrecognised_compliance)
        .with(type, [zone_id])
        .and_return(unrecognised_response)
    end

    it 'calls :unrecognised_compliance with right params' do
      details.zone_name
      expect(ComplianceCheckerApi).to have_received(:unrecognised_compliance).with(type, [zone_id])
    end

    it_behaves_like 'compliance details fields'

    describe 'phgv_discount_available?' do
      context 'when phgvDiscountAvailable is true in compliance endpoint' do
        it 'returns false' do
          expect(details).not_to be_phgv_discount_available
        end
      end

      context 'when phgvDiscountAvailable is false in compliance endpoint' do
        let(:phgv_discount_available) { false }

        it 'returns true' do
          expect(details).not_to be_phgv_discount_available
        end
      end
    end
  end
end
