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
          'publicTransportOptions' => url
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

      describe '.dynamic_compliance_url' do
        describe 'when additional_compliance_url is present' do
          let(:taxidiscountcaz_urls) { YAML.load_file('additional_url.yml')['taxidiscountcaz'] }

          it 'returns additional_compliance_url for taxidiscountcaz' do
            expect(details.dynamic_compliance_url).to eq(taxidiscountcaz_urls['fleet'])
          end

          describe 'taxi' do
            before { vehicle_details.merge!('weekly_taxi' => true) }

            it 'returns taxidiscountcaz non fleet url' do
              expect(details.additional_compliance_url).to eq(taxidiscountcaz_urls['non_fleet'])
            end
          end
        end

        describe 'when additional_compliance_url is not present' do
          let(:name) { 'Bath' }

          it 'returns compliance_url' do
            expect(details.dynamic_compliance_url).to eq(details.compliance_url)
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

      describe 'additional_compliance_url' do
        describe 'Taxidiscountcaz' do
          let(:taxidiscountcaz_urls) { YAML.load_file('additional_url.yml')['taxidiscountcaz'] }

          it 'returns taxidiscountcaz fleet url' do
            expect(details.additional_compliance_url).to eq(taxidiscountcaz_urls['fleet'])
          end

          describe 'taxi' do
            before { vehicle_details.merge!('weekly_taxi' => true) }

            it 'returns taxidiscountcaz non fleet url' do
              expect(details.additional_compliance_url).to eq(taxidiscountcaz_urls['non_fleet'])
            end
          end
        end

        describe 'Birmingham' do
          let(:name) { 'Birmingham' }
          let(:birmingham_urls) { YAML.load_file('additional_url.yml')['birmingham'] }

          it 'returns birmingham fleet url' do
            expect(details.additional_compliance_url).to eq(birmingham_urls['fleet'])
          end

          describe 'car' do
            let(:type) { 'car' }

            it 'returns birmingham non_fleet url' do
              expect(details.additional_compliance_url).to eq(birmingham_urls['non_fleet'])
            end
          end

          describe 'undefined' do
            let(:type) { nil }

            it 'returns birmingham fleet url' do
              expect(details.additional_compliance_url).to eq(birmingham_urls['fleet'])
            end
          end
        end

        describe 'Bath' do
          let(:name) { 'Bath' }
          let(:bath_urls) { YAML.load_file('additional_url.yml')['bath'] }

          it 'returns nil' do
            expect(details.additional_compliance_url).to be_nil
          end
        end
      end
    end

    context 'when vehicle is unrecognised' do
      let(:unrecognised) { true }

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
