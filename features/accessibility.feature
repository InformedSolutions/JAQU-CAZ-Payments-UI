Feature: Accessibility statement
  In order to read the page
  As a user
  I want to see accessibility statement page

  Scenario: User sees accessibility statement page
    Given I am on the home page
    When I press "Accessibility statement" footer link
    Then I should see "Accessibility statement"