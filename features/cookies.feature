Feature: Cookies
  In order to know more about the cookies
  As a user
  I want to see cookies page

  Scenario: User sees cookies page
    Given I am on the home page
    When I press "Cookies" footer link
    Then I should be on the cookies page
      And I should see "Cookies" title
