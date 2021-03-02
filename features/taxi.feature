Feature: Taxidiscountcaz Taxi
  In order to pay the charge with a Taxidiscountcaz weekly discount
  As a user
  I want to be able to select weekly payment flow

  Scenario: User enters a taxi vehicle's registration and choose Pay for 7 days
    Given I am on the vehicle details page with taxi vehicle to check
      And I have already paid for today
    Then I choose that the details are correct
      And I press the Confirm
    Then I select Taxidiscountcaz
      And I press the Continue
      And I should be on the select period page
      And I should see 'How many days do you want to pay for?'
    Then I press the Continue
      And I should see 'Choose to pay for 1 day or 7 days'
    Then I select Pay for 7 days
      And I press the Continue
      And I should see 'Pay a weekly Taxidiscountcaz Clean Air Zone charge'
    Then I press the Continue
      And I should see 'Confirm you have checked if you are eligible for an exemption'
    When I choose I confirm that I am not exempt
    Then I press the Continue
      And I should be on the pick weekly dates page
      And I should see 'When do you want your weekly charge to start?'
    Then I press the Continue
      And I should see 'Select a start date for the week that you wish to pay for'

  Scenario: User enters a taxi vehicle's registration and choose Pay for 7 days when a week charge starting from today
    Given I am on the vehicle details page with taxi vehicle to check
      And I am not paid for today
    When I choose that the details are correct
      And I press the Confirm
    Then I select Taxidiscountcaz
      And I press the Continue
    Then I select Pay for 7 days
      And I press the Continue
    Then I choose I confirm that I am not exempt
      And I press the Continue
    Then I should be on the pick weekly charge period page
      And I should see 'When would you like your weekly charge to start?' title
      And I select 'Another'
      And I press the Continue
    Then I should be on the pick weekly dates page
      And I press the Continue
    Then I should see 'Select a start date for the week that you wish to pay for'

  Scenario: User enters a taxi vehicle's registration when he already paid for tomorrow
    Given I am on the vehicle details page with taxi vehicle to check
      And I have already paid for tomorrow
    When I choose that the details are correct
      And I press the Confirm
    Then I select Taxidiscountcaz
      And I press the Continue
    Then I select Pay for 7 days
      And I press the Continue
    Then I choose I confirm that I am not exempt
      And I press the Continue
    Then I should be on the pick weekly dates page

  Scenario: User enters a taxi vehicle's registration and choose Pay for 1 day
    Given I am on the vehicle details page with taxi vehicle to check
    Then I choose that the details are correct
      And I press the Confirm
    Then I select Taxidiscountcaz
      And I press the Continue
    Then I press the Continue
    Then I select Pay for 1 day
      And I press the Continue
      And I should see 'Pay a daily Taxidiscountcaz Clean Air Zone charge'

  Scenario: User selects dates to pay for and d-day is within date range you can pay
    Given I am on the weekly dates page when d-day was yesterday and today day is paid
    Then I should be on the pick weekly dates page
      And I should see "Why can’t I select certain dates?"

  Scenario: User selects dates to pay for and d-day is within date range you can pay
    Given I am on the weekly dates page when d-day will be tomorrow
    Then I should be on the pick weekly dates page
      And I should see "Why can’t I select certain dates?"

  Scenario: User selects dates to pay for and d-day already passed and is outside of date range
    Given I am on the weekly dates page when d-day was 7 days ago and today day is paid
    Then I should be on the pick weekly dates page
      And I should not see 'The Clean Air Zone charge came into operation on'

  Scenario: User selects dates to pay for and d-day already passed and is outside of date range
    Given I am on the weekly dates page when d-day was 7 days ago and today day is not paid
    Then I should be on the pick weekly charge period page

  Scenario: User wants to select two weeks
    Given I am on the weekly dates page
      And I fill in an available week start date
      And I press the Continue
      And I press 'Add another week' link
    Then I should be on the pick second weekly dates page
      And I fill in an available second week start date
      And I press the Continue
      And I should not see 'Add another week'

  Scenario: User wants to select two weeks but enters invalid second date
    Given I am on the weekly dates page
      And I fill in an available week start date
      And I press the Continue
    Then I should be on the review your payment page
      And I should see 'Add another week'
      And I press 'Add another week' link
    Then I should be on the pick second weekly dates page
      And I fill in an invalid second week start date
      And I press the Continue
    Then I should be on the pick second weekly dates page
      And I should see "Choose a start date for your second week that doesn't include dates"

  Scenario: User wants to pay for a taxi which has incomplete DVLA data
    Given I am on the vehicle details page with unrecognized taxi vehicle to check
      And I am not paid for today
    When I choose that the details are correct
      And I press the Confirm
    Then I select Birmingham
      And I press the Continue
    Then I should be on the daily charge page
      And I should see 'If your vehicle does meet Clean Air standards, you can claim a refund when your vehicle details are updated.'
      And I confirm exemption
      And I press the Continue
    Then I should be on the pick daily dates page
