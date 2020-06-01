Feature: Refund
  In order to get a refund
  As a user
  I want to be able to refund rules

  Scenario: User wants to to know in what scenarios he can claim a refund
    Given I am on the refunds scenarios page
      And I should see "Can I claim a refund?"
    Then I press the Continue
      And I should see "Claim a refund"
