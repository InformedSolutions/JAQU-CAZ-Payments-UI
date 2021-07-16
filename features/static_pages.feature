Feature: Static Pages
  In order to read the page
  As a user
  I want to see the static pages

  Scenario: User sees accessibility statement page
    Given I am on the home page
    When I press 'Accessibility statement' footer link
    Then I should see 'Accessibility statement for Drive in a Clean Air Zone'

  Scenario: User sees cookies page
    Given I am on the home page
    When I press 'Cookies' footer link
    Then I should see 'Cookies' title
      And I should see 'A cookie is a small piece of data'

  Scenario: User sees privacy notice page
    Given I am on the home page
    When I press Privacy footer link
    Then I should see 'Privacy Notice' title
      And I should see 'Check a single vehicle'

  Scenario: User sees terms and conditions page
    Given I am on the home page
    When I press 'Terms and conditions' footer link
    Then I should see 'Terms and conditions' title
