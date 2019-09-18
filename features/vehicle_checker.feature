Feature: Vehicle Checker
  In order to read the page
  As a user
  I want to be able to enter a vehicle's registration
    And see details of a car

  Scenario: User wants to check vehicle
    Given I am on the home page
    Then I should see "Start now"
      And I press the Start now button
    Then I should see the Vehicle page
      And I should see "Pay a Clean Air Zone charge" title
      And I should see "Enter the registration details of the vehicle you wish to check"
