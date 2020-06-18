Feature: Leeds Taxi
  In order to pay the charge with a Leeds weekly discount
  As a user
  I want to be able to select weekly payment flow

  Scenario: User enters a taxi vehicle's registration and choose Pay for 7 days
    Given I am on the vehicle details page with taxi vehicle to check
      And I have already paid for today
    Then I choose that the details are correct
      And I press the Confirm
    Then I select Leeds
      And I press the Continue
      And I should be on the select period page
      And I should see 'How many days do you want to pay for?'
    Then I press the Continue
      And I should see 'Choose to pay for 1 day or 7 days'
    Then I select Pay for 7 days
      And I press the Continue
      And I should see 'Pay a weekly Leeds Clean Air Zone charge'
    Then I press the Continue
      And I should see 'Confirm you have checked if you are eligible for an exemption'
    When I choose I confirm that I am not exempt
    Then I press the Continue
      And I should be on the pick weekly dates page
      And I should see 'Choose your dates'
      And I should see 'The Clean Air Zone charge came into operation on'
    Then I press the Continue
      And I should see 'Select a week that you wish to pay for'
    Then I select any available day
      And I press the Continue
    Then I should be on the review your payment page

  Scenario: User enters a taxi vehicle's registration and choose Pay for 7 days when a week charge starting from today
    Given I am on the vehicle details page with taxi vehicle to check
      And I am not paid for today
    When I choose that the details are correct
      And I press the Confirm
    Then I select Leeds
      And I press the Continue
    Then I select Pay for 7 days
      And I press the Continue
    Then I choose I confirm that I am not exempt
      And I press the Continue
    Then I should be on the pick weekly charge period page
      And I should see 'When would you like your weekly charge to start?' title
      And I press 'Back' link
    Then I should be on the weekly charge page
      And I press the Continue
    Then I should see 'State if you would like your weekly charge to start today or another day'
      And I select 'Today'
      And I press the Continue
    Then I should be on the review your payment page
      And I press 'Back' link
    Then I should be on the pick weekly charge period page
      And I press the Continue
    Then I should be on the review your payment page
      And I press 'Back' link
    Then I select 'Another'
      And I press the Continue
    Then I should be on the pick weekly dates page

  Scenario: User enters a taxi vehicle's registration when he already paid for tomorrow
    Given I am on the vehicle details page with taxi vehicle to check
      And I have already paid for tomorrow
    When I choose that the details are correct
      And I press the Confirm
    Then I select Leeds
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
    Then I select Leeds
      And I press the Continue
    Then I press the Continue
    Then I select Pay for 1 day
      And I press the Continue
      And I should see 'Pay a daily Leeds Clean Air Zone charge'

  Scenario: User already paid for some days on weekly flow
    Given I have already paid for today
      And I am on the weekly dates page
    Then I should see a disabled 'current' radio
      And I should see a disabled 'yesterday' radio
      And I should see an active 'tomorrow' radio
    Then I choose a time-frame that was already paid
      And I press the Continue
    Then I should see 'You have already paid for at least one day in the selected week'

  Scenario: User selects dates to pay for and d-day is within date range you can pay
    Given I am on the weekly dates page when d-day was yesterday and today day is paid
    Then I should be on the pick weekly dates page
      And I should see "Why can't I see my dates?"

  Scenario: User selects dates to pay for and d-day is within date range you can pay
    Given I am on the weekly dates page when d-day will be tomorrow
    Then I should be on the pick weekly dates page
      And I should see "Why can't I see my dates?"

  Scenario: User selects dates to pay for and d-day already passed and is outside of date range
    Given I am on the weekly dates page when d-day was 7 days ago and today day is paid
    Then I should be on the pick weekly dates page
      And I should not see 'The Clean Air Zone charge came into operation on'

  Scenario: User selects dates to pay for and d-day already passed and is outside of date range
    Given I am on the weekly dates page when d-day was 7 days ago and today day is not paid
    Then I should be on the pick weekly charge period page
