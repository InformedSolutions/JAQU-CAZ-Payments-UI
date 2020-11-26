Feature: Payments
  In order to pay the charge
  As a user
  I want to proceed to the payment process

  Scenario: User wants to start the payment process
    Given I am on the review payment page
      And I press the Continue
    Then I should get redirected to the GOV.UK Pay page
      And I should have payment id in the session

  Scenario: User wants to finalize payment process
    Given I have finished the payment successfully
      And I'm getting redirected from GOV.UK Pay
    Then I should be on the successful payments page

  Scenario: User wants to finalize unsuccessful payment process
    Given I have finished the payment unsuccessfully
      And I'm getting redirected from GOV.UK Pay
    Then I should be on the failed payments page

  Scenario: User wants to pay for another CAZ
    Given I have finished the payment successfully
      And I'm getting redirected from GOV.UK Pay
    Then I press pay for another CAZ
      And I should be on the local authorities page

  Scenario: User could only pay for one CAZ
    Given I have finished the payment successfully
      And I'm getting redirected from GOV.UK Pay
    When I am only chargeable in one Clean Air Zone
    Then I should not see pay for another CAZ link

  Scenario: User wants to go back to the start after unsuccessful payment process
    Given I have finished the payment unsuccessfully
      And I'm getting redirected from GOV.UK Pay
    Then I press "return to the start page" link
      And I should be on the start page

  Scenario: User wants to pay for another vehicle after successful payment process
    Given I have finished the payment successfully
      And I'm getting redirected from GOV.UK Pay
    Then I press 'Pay for another vehicle' link
      And The LA inputs should not be filled
    Then I press the Continue
      And The LA inputs should not be filled
