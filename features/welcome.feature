Feature: Welcome
  In order to read the page
  As a viewer
  I want to see the home page of my app

  Scenario: View welcome page
    Given I am on the home page
    Then I should see "Pay a Clean Air Zone charge"
      And I should see "Pay a Clean Air Zone charge" title
