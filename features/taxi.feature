Feature: Charges
  In order to pay the charge in the right place
  As a user
  I want to be able to select right charge details

  Scenario: User enters a taxi vehicle's registration and choose Pay for 7 days
    Given I am on the vehicle details page with taxi vehicle to check
    Then I choose that the details are correct
      And I press the Confirm
    Then I select Leeds
      And I press the Continue
      And I should see "How many days do you want to pay for?"
    Then I press the Continue
      And I should see "State if you are paying for 1 day or 7 days"
    Then I select Pay for 7 days
      And I press the Continue
      And I should see "Pay a Leeds Clean Air Zone weekly charge"
    Then I press the Continue
      And I should see "Confirm you have checked if you are eligible for an exemption"
    Then I choose I confirm that I am not exempt
      And I press the Continue
      And I should see "When do you want your 7-day period to start?"
    Then I press the Continue
      And I should see "Select a date that you wish to pay for"
    Then I select Today
      And I press the Continue
    Then I should see "Review your payment"

  Scenario: User enters a taxi vehicle's registration and choose Pay for 1 day
    Given I am on the vehicle details page with taxi vehicle to check
    Then I choose that the details are correct
      And I press the Confirm
    Then I select Leeds
      And I press the Continue
    Then I press the Continue
    Then I select Pay for 1 day
      And I press the Continue
      And I should see "Pay a Leeds Clean Air Zone charge"
