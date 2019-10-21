Feature: Payments
  In order to pay the charge
  As a user
  I want to proceed to the  payment process

  Scenario: User wants to start the payment process
    Given I am on the review payment page
      And I press the Continue
    Then I should be on the payments page
      And I should have payment id in the session

