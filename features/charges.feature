Feature: Charges
  In order to pay the charge in the right place
  As a user
  I want to be able to select right charge details

  Scenario: User wants to return with right vehicle data for vehicle registered in the UK
    Given I am on the vehicles details page
    Then I choose that the details are correct
      And I press the Confirm
      And I should be on the local authorities page

  Scenario: User wants to return with wrong vehicle data for vehicle registered in the UK
    Given I am on the vehicles details page
    Then I choose that the details are incorrect
      And I press the Confirm
    Then I should be on the incorrect details page
      And I press the Continue
      And I should be on the local authorities page

  Scenario: User wants to return with vehicle registered not in the UK
    Given I am on the choose type page for non-UK vehicle
    Then I choose Car type
      And I press the Confirm
      And I should be on the local authorities page

  Scenario: User wants to return to type selection when his vehicle is UK and not recognised
    Given I am on the choose type page for UK vehicle
    Then I choose Car type
      And I press the Confirm
      And I should be on the local authorities page

  Scenario: User selects LA to pay for
    Given My vehicle is not compliant
      And I am on the select local authority page
    Then I press the Continue
      And I should see "There is a problem"
      And I should see "You must choose one Clean Air Zone"
    Then I select Birmingham
      And I press the Continue
    Then I should be on the daily charge page
      And I should not see 'If your vehicle does meet Clean Air standards, you can claim a refund when your vehicle details are updated.'
      And I should see "Pay a daily Birmingham Clean Air Zone charge"

  Scenario: Vehicle is compliant in all CAZ
    Given My vehicle is compliant
      And I am go the local authority page
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
    Then I should be on the pick daily dates page

  Scenario: User selects dates to pay for
    Given I am on the dates page
      And I should see "Which days do you want to pay for?"
    Then I press the Continue
      And I should see "Select a date that you wish to pay for"
    Then I choose today date
      And I press the Continue
    Then I should see "Review your payment"
      And I have selected dates in the session

  Scenario: User wants review payment and press the change registration number link
    Given I am on the review payment page
      And I should see "Review your payment"
    Then I press the Change Registration number link
      And I should be on the enter details page

  Scenario: User wants review payment and press the change clean air zone link
    Given I am on the review payment page
      And I should see "Review your payment"
    Then I press the Change Clean Air Zone link
      And I should see "Which Clean Air Zone do you need to pay for?"

  Scenario: User wants to review payment and cannot see a change clean air zone link
    Given I am on the review payment page
      And I should see "Review your payment"
    When I am only chargeable in one Clean Air Zone
    Then I should not see the Change Clean Air Zone link

  Scenario: User wants review daily payment and press the change payment for link
    Given I am on the review payment page
      And I should see "Review your payment"
    Then I press the Change Payment for link
      And I should be on the pick daily dates page

  Scenario: User wants review weekly payment and press the change payment for link
    Given I am on the review weekly payment page
      And I should see "Review your payment"
    Then I press the Change Payment for link
      And I should be on the pick weekly dates page

  Scenario: User wants review weekly payment and press the change payment for link when a week charge starting from today
    Given I am on the review weekly payment page when a week charge starting from today
      And I should see "Review your payment"
    Then I press the Change Payment for link
      And I should be on the pick weekly charge period page

  Scenario: User wants to paid for already paid date
    Given I am on the dates page with paid charge for today
    Then I should see a disabled today checkbox
      And I should see "If you can't select the date you want"
    Then I choose a date that was already paid
      And I press the Continue
    Then I should be on the pick daily dates page
      And I should see "You have already paid for at least one of the selected dates"

  Scenario: User cannot pay for any more dates
    Given I am on the dates page with all charges paid
      And I should see "You paid for everything"
    Then I should not see the continue button

  Scenario: User cannot buy an overlapping pass
    Given I am on the pick weekly dates page with no passes available to buy
      And I should see "you have paid for a date in those 7 consecutive days"
    Then I should not see the continue button

  Scenario: User selects dates to pay for and d-day is within date range you can pay
    Given I am on the dates page when d-day was yesterday
    Then I should be on the pick daily dates page
      And I should see 'The Clean Air Zone charge came into operation on'

  Scenario: User selects dates to pay for and d-day is within date range you can pay
    Given I am on the dates page when d-day will be tomorrow
    And I should not see 'The Clean Air Zone charge came into operation on'
