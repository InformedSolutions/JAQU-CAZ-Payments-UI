Feature: Privacy Notice
  In order to know about privacy policies
  As a user
  I want to see privacy notice page

  Scenario: User sees accessibility statement page
    Given I am on the home page
    When I press "Privacy Notice" footer link
    Then I should be on the privacy notice page
      And I should see "Privacy Notice" title
