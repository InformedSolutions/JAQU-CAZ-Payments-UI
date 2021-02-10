Feature: Vehicles
  In order to read the page
  As a user
  I want to be able to enter a vehicle's registration
    And see details of a car

  Scenario: User wants to check vehicle
    Given I am on the home page
    Then I should see 'Start now'
      And I press the Start now button
    Then I should be on the enter details page
      And I should see 'Enter the number plate of the vehicle | Drive in a Clean Air Zone' title
      And I should see 'Enter the number plate of the vehicle'
    Then I enter a only vehicle's registration
      And I press the Continue
      And I should see 'Choose UK or Non-UK'
    Then I choose only UK country
      And I press the Continue
      And I should see 'Enter the number plate of the vehicle'

  Scenario: User enters a correct vehicle's registration and choose what vehicle's details are incorrect
    Given I am on the home page
    Then I press the Start now button
      And I should be on the enter details page
    Then I enter a vehicle's registration and choose UK
      And I press the Continue
      And I should see 'Are these vehicle details correct?'
      And I should see 'Are these vehicle details correct? | Drive in a Clean Air Zone' title
      And I press the Confirm
    Then I should see 'Select yes if the details are correct'
      And I choose that the details are incorrect
      And I press the Confirm
    Then I should see 'Incorrect vehicle details'
      And I press the Continue
    Then I should see 'Which Clean Air Zone do you need to pay for?'

  Scenario: User enters a correct vehicle's registration and choose Non-UK country (not exempted)
    Given I am on the home page
    Then I press the Start now button
      And I should be on the enter details page
    Then I enter a not-exempted non-UK vehicle's registration
      And I press the Continue
    Then I should see 'Your vehicle is registered outside the UK'
      And I press the Continue
    Then I should see 'Confirm the number plate is correct'
      And I should see 'There is a problem'
      And I should be on the non UK page
    Then I choose I confirm registration
      And I press the Continue
    Then I should see 'What is your vehicle?'
      And I press the Confirm
    Then I should see 'Tell us what type of vehicle you want to pay for'
      And I should see 'There is a problem'
      And I choose Car type
      And I press the Confirm
    Then I should see 'Which Clean Air Zone do you need to pay for?'

  Scenario: User enters a correct vehicle's registration and choose Non-UK country (exempted)
    Given I am on the home page
    Then I press the Start now button
      And I should be on the enter details page
    Then I enter an exempted non-UK vehicle's registration
      And I press the Continue
    Then I should see 'There is no charge for this vehicle'
      And I should see 'There is no charge for this vehicle | Drive in a Clean Air Zone' title

  Scenario: User enters a correct UK vehicle's registration, choose Non-UK country (fraud detection) and choose that vehicle's details are correct
    Given I am on the home page
    Then I press the Start now button
      And I should be on the enter details page
    Then I enter an UK vehicle's registration and choose Non-UK country
      And I press the Continue
    Then I should see 'Your vehicle is UK registered'
      And I should see 'Your vehicle is UK registered | Drive in a Clean Air Zone' title

  Scenario: User enters a correct UK vehicle's registration, choose Non-UK country (fraud detection) and choose that vehicle's details are incorrect
    Given I am on the home page
    Then I press the Start now button
      And I should be on the enter details page
    Then I enter an UK vehicle's registration and choose Non-UK country
      And I press the Continue
    Then I should see 'Your vehicle is UK registered'
      And I should see 'Your vehicle is UK registered | Drive in a Clean Air Zone' title

  Scenario: User enters a vehicle's registration which cannot be recognised
    Given I am on the home page
    Then I press the Start now button
      And I should be on the enter details page
    Then I enter a unrecognised vehicle's registration and choose UK
      And I press the Continue
    Then I should see 'Vehicle details could not be found'
      And I press the Continue
    Then I should see 'Confirm the number plate is correct'
      And I should see 'There is a problem'
      And I should be on the unrecognised page
    Then I choose I confirm registration
      And I press the Continue
    Then I should see 'What is your vehicle?'

  Scenario: User enters a compliant vehicle's registration and choose UK country
    Given I am on the home page
    Then I press the Start now button
      And I should be on the enter details page
    Then I enter a compliant vehicle's registration and choose UK
      And I press the Continue
      And I should see 'Are these vehicle details correct?'
    Then I choose that the details are correct
      And I press the Confirm
      And I should see 'There is no charge for this vehicle'

  Scenario: User enters a exempt vehicle's registration and choose UK country
    Given I am on the home page
    Then I press the Start now button
    Then I enter a exempt vehicle's registration and choose UK
      And I press the Continue
    Then I should see 'There is no charge for this vehicle'

  Scenario: User wants to return with vehicle's registration which cannot be recognised
    Given I am on the vehicle details page with unrecognized vehicle to check
    Then I choose I confirm registration
      And I press the Continue
      And I should be on the choose type page

  Scenario: User wants to pay for incomplete (not able to get compliance from VCCS) vehicle
    Given I am on the home page
      Then I press the Start now button
        And I should be on the enter details page
      Then I enter an incomplete vehicle's registration and choose UK
        And I press the Continue
        And I should see 'Are these vehicle details correct?'
      Then I choose that the details are correct
        And I press the Confirm
        And I should see 'Vehicle details are incomplete'
        And I should see 'What is your vehicle?'
        And I choose Car type
        And I press the Confirm
        And I should see 'Which Clean Air Zone do you need to pay for?'

  Scenario: User wants to pay for a taxi which is not registered in the DVLA
    Given I am on the home page
      Then I press the Start now button
        And I should be on the enter details page
      Then I enter an unrecognised taxi registration number and choose UK
        And I press the Continue
        And I should be on the unrecognised page
      Then I choose I confirm registration
        And I press the Continue
        And I should be on the local authorities page

  Scenario: User wants to pay for undetermined (without type) correct vehicle
    Given I am on the home page
      Then I press the Start now button
        And I should be on the enter details page
      Then I enter an undetermined vehicle's registration and choose UK
        And I press the Continue
        And I should see 'Are these vehicle details correct?'
      Then I choose that the details are correct
        And I press the Confirm
        And I should see 'Vehicle details are incomplete'
        And I should see 'What is your vehicle?'
        And I choose Car type
        And I press the Confirm
      Then I should see 'Which Clean Air Zone do you need to pay for?'

  Scenario: User wants to pay for non active Clean Air Zone
    Given I am on the home page
      Then I press the Start now button
        And I should be on the enter details page
    Then I enter a vehicle's registration but the zones are not active
      And I press the Continue
      And I should see 'Are these vehicle details correct?'
    Then I choose that the details are correct
      And I press the Confirm
      And I should see 'There is no charge for this vehicle'
      And I should see 'There is no charge for this vehicle | Drive in a Clean Air Zone' title

  Scenario: User wants to pay for undetermined (without type) incorrect vehicle
    Given I am on the home page
      Then I press the Start now button
        And I should be on the enter details page
      Then I enter an undetermined vehicle's registration and choose UK
        And I press the Continue
        And I should see 'Are these vehicle details correct?'
      Then I choose that the details are incorrect
        And I press the Confirm
        And I should see 'Incorrect vehicle details'
      Then I press the Continue
        And I should see 'Vehicle details are incomplete'
        And I should see 'What is your vehicle?'
      Then I choose Car type
        And I press the Confirm
      Then I should see 'Which Clean Air Zone do you need to pay for?'
