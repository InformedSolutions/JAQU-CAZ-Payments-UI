# frozen_string_literal: true

# rubocop:disable all
# :nodoc: all
class MockVrnResponse
  def initialize(vrn)
    @vrn = vrn
  end

  def response
    case vrn
    when 'ABC123'
      leeds_taxi
    when 'GHI567'
      lgv
    when 'DEF789'
      hgv
    when 'CU57ABC'
      car
    when 'JKL987'
      bus
    when 'CDE345'
      compliant_car
    else
      raise BaseApi::Error404Exception.new(404, 'not found', {
        "registration_number": vrn,
        "message": "Vehicle with registration number #{vrn} was not found"
      })
    end
  end

  private

  attr_reader :vrn

  def leeds_taxi
    {
      'registration_number' => 'ABC123',
      'typeApproval' => 'M1',
      'type' => 'car',
      'make' => 'Peugeot',
      'model' => '208',
      'colour' => 'grey',
      'fuelType' => 'diesel',
      'taxiOrPhv' => true
    }
  end

  def lgv
    {
      'registration_number' => 'GHI567',
      'type' => 'car',
      'make' => 'Fiat',
      'model' => 'Panda',
      'colour' => 'black',
      'fuelType' => 'petrol',
      'taxiOrPhv' => false
    }
  end

  def hgv
    {
      'registration_number' => 'DEF789',
      'typeApproval' => 'N3',
      'type' => 'car',
      'make' => 'Volvo',
      'model' => 'B5TL',
      'colour' => 'white',
      'fuelType' => 'diesel',
      'taxiOrPhv' => false
    }
  end

  def bus
    {
      'registration_number' => 'JKL987',
      'typeApproval' => 'N3',
      'type' => 'car',
      'make' => 'Toyota',
      'model' => 'Yaris',
      'colour' => 'white',
      'fuelType' => 'diesel',
      'taxiOrPhv' => false
    }
  end

  def unrecognised_vehicle
    {
      'registration_number' => 'XYZ456',
      'type' => 'Null'
    }
  end

  def compliant_car
    {
      'registration_number' => 'CDE345',
      'typeApproval' => 'M1',
      'type' => 'car',
      'make' => 'Tesla',
      'model' => 'Model 3',
      'colour' => 'white',
      'fuelType' => 'electric',
      'taxiOrPhv' => false
    }
  end

  def car
    {
      'registration_number' => 'CU57ABC',
      'typeApproval' => 'M1',
      'type' => 'car',
      'make' => 'Ford',
      'model' => 'Focus',
      'colour' => 'white',
      'fuelType' => 'diesel',
      'taxiOrPhv' => false
    }
  end
end
# rubocop:enable all
