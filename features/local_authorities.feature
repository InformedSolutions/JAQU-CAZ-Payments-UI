Feature: Local Authorities
  In order to pay the charge in the right place
  As a user
  I want to be able to select right local authority

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
    Given I am on the the local authorities page
    Then I press "Back" link
      And I should be on the enter details page
