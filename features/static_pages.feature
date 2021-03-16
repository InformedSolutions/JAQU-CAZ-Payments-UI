Feature: Static Pages
  In order to read the page
  As a Licensing Authority
  I want to see the static pages

  Scenario: User sees accessibility statement page
    Given I am on the home page
    When I press 'Accessibility statement' footer link
    Then I should see 'Accessibility statement for Drive in a Clean Air Zone'

  Scenario: User sees cookies page
    Given I am on the home page
    When I press 'Cookies' footer link
    Then I should see 'Cookies'
      And I should see 'A cookie is a small piece of data'

  Scenario: User sees privacy notice page
    Given I am on the home page
    When I press 'Privacy' footer link
    Then I should see 'Privacy Notice'
      And I should see 'Check a single vehicle'
