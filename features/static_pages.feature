Feature: Static Pages
  In order to read the page
  As a Licensing Authority
  I want to see the static pages

  Scenario: User sees accessibility statement page
    Given I am on the home page
    When I press "Accessibility statement" footer link
    Then I should see "Accessibility statement for Pay a Clean Air Zone Charge"

  Scenario: User sees cookies page
    Given I am on the home page
    When I press "Cookies" footer link
    Then I should see "Cookies"
      And I should see "A cookie is a small piece of data"

  Scenario: User sees privacy notice page
    Given I am on the home page
    When I press "Privacy Notice" footer link
    Then I should see "Privacy Notice"
      And I should see "To use Pay a Clean Air Zone charge charge"

  Scenario: Testing back button when I am on enter details page
    Given I am on the enter details page
    When I press "Accessibility statement" footer link
      And I should be on the accessibility statement page
      And I press "Back" link
    Then I should be on the enter details page
    When I press "Cookies" footer link
      And I should be on the cookies page
      And I press "Back" link
    Then I should be on the enter details page
    When I press "Privacy Notice" footer link
      And I should be on the privacy notice page
      And I press "Back" link
    Then I should be on the enter details page
