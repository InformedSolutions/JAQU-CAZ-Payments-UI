Feature: Payments
  In order to pay the charge
  As a user
  I want to proceed to the  payment process

  Scenario: User wants to start the payment process
    Given I am on the review payment page
      And I press the Continue
    Then I should get redirected to the GOV.UK Pay page
      And I should have payment id in the session

  Scenario: User wants to to finalize payment process
    Given I have finished the payment successfully
      And I'm getting redirected from GOV.UK Pay
    Then I should be on the successful payments page

  Scenario: User wants to to finalize payment process
    Given I have finished the payment unsuccessfully
      And I'm getting redirected from GOV.UK Pay
    Then I should be on the failed payments page


