Feature: Charges
  In order to pay the charge in the right place
  As a user
  I want to be able to select right charge details

  Scenario: User wants to return with right vehicle data for vehicle registered in the UK
    Given I am on the vehicles details page
    Then I choose that the details are correct
      And I press the Confirm
    Then I should be on the local authorities page
    Then I press "Back" link
      And I should be on the vehicle details page

  Scenario: User wants to return with wrong vehicle data for vehicle registered in the UK
    Given I am on the vehicles details page
    Then I choose that the details are incorrect
      And I press the Confirm
    Then I should be on the incorrect details page
      And I press the Continue
    Then I should be on the local authorities page
    Then I press "Back" link
      And I should be on the incorrect details page

  Scenario: User wants to return with vehicle registered not in the UK
    Given I am on the choose type page
    Then I choose Car type
      And I press the Confirm
    Then I should be on the local authorities page
    Then I press "Back" link
      And I should be on the choose type page

  Scenario: User wants to return without the previous page
    Given I am on the select local authority page
    Then I press "Back" link
      And I should be on the enter details page

  Scenario: User selects LA to pay for
    Given My vehicle is not compliant
      And I am on the select local authority page
    Then I select Birmingham
      And I press the Continue
    Then I should be on the daily charge page

  Scenario: Vehicle is compliant in all CAZ
    Given My vehicle is compliant
      And I am on the select local authority page
    Then I should be on the compliant vehicle page

  Scenario: User does not confirm exemption
    Given I am on the daily charge page
      And I press the Continue
    Then I should be on the daily charge page
      And I should see "Confirm you have checked if you are eligible for an exemption"

  Scenario: User confirms exemption
    Given I am on the daily charge page
      And I confirm exemption
      And I press the Continue
    Then I should be on the pick dates page
