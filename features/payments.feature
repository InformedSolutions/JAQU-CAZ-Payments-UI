Feature: Payments
  In order to pay the charge
  As a user
  I want to proceed to the  payment process

  Scenario: User wants to start the payment process
    Given I am on the review payment page
      And I press the Continue
    Then I should be on the payments complete page
#    Then I should get redirected to the GOV.UK Pay page
      And I should have payment id in the session

  Scenario: User wants to to complete payment process
    Given I am on the review payment page
      And I press the Continue
    Then I should be on the payments complete page
      And I should have payment id in the session
      And I should see "Payment complete"

