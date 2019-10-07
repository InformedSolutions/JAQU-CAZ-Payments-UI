Feature: Vehicles
  In order to read the page
  As a user
  I want to be able to enter a vehicle's registration
    And see details of a car

  Scenario: User wants to check vehicle
    Given I am on the home page
    Then I should see "Start now"
      And I press the Start now button
    Then I should be on the enter details page
      And I should see "Pay a Clean Air Zone charge" title
      And I should see "Vehicle registration details"
    Then I enter a only vehicle's registration
      And I press the Continue
      And I should see "Tell us if your vehicle is UK or non-UK registered"
    Then I choose only UK country
      And I press the Continue
      And I should see "Enter the registration number of the vehicle"

  Scenario: User enters a correct vehicle's registration and choose UK country
    Given I am on the home page
    Then I press the Start now button
      And I should see "Vehicle registration details"
    Then I enter a vehicle's registration and choose UK
      And I press the Continue
    Then I should see "Are these the vehicle's details?"

  Scenario: User enters a correct vehicle's registration and choose what vehicle's details are incorrect
    Given I am on the home page
    Then I press the Start now button
      And I should see "Vehicle registration details"
    Then I enter a vehicle's registration and choose UK
      And I press the Continue
      And I should see "Are these the vehicle's details?"
    Then I press the Confirm
      And I should see "You must choose an answer"
      And I should see "Select yes if the details are correct"
    Then I choose that the details are incorrect
      And I press the Confirm
      And I should see "Incorrect vehicle details"
    Then I press the Continue
      And I should see "Which Clean Air Zone do you need to pay for?"

  Scenario: User enters a correct vehicle's registration and choose Non-UK country
    Given I am on the home page
    Then I press the Start now button
      And I should see "Vehicle registration details"
    Then I enter a vehicle's registration and choose Non-UK
      And I press the Continue
    Then I should see "Your vehicle is not UK-Registered"
      And I press the Continue
    Then I should see "Confirm that the registration number is correct"
      And I should be on the non UK page
    Then I choose I confirm registration
      And I press the Continue
    Then I should see "What is your vehicle?"
      And I press the Confirm
    Then I should see "Tell us what type of vehicle you want to pay for"
      And I choose Car type
      And I press the Confirm
    Then I should see "Which Clean Air Zone do you need to pay for?"

  Scenario: User enters a vehicle's registration which cannot be recognised
    Given I am on the home page
    Then I press the Start now button
      And I should see "Vehicle registration details"
    Then I enter a unrecognised vehicle's registration and choose UK
      And I press the Continue
    Then I should see "Vehicle details not found"
      And I press the Continue
    Then I should see "Confirm that the registration number is correct"
      And I should be on the unrecognised page
    Then I choose I confirm registration
      And I press the Continue
    Then I should see "What is your vehicle?"

