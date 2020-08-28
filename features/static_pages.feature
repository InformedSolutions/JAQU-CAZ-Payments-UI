Feature: Static Pages
  In order to read the page
  As a Licensing Authority
  I want to see the static pages

  Scenario: User sees accessibility statement page
    Given I am on the home page
    When I press "Accessibility statement" footer link
    Then I should see "Accessibility statement for Drive in a Clean Air Zone"

  Scenario: User sees cookies page
    Given I am on the home page
    When I press "Cookies" footer link
    Then I should see "Cookies"
      And I should see "A cookie is a small piece of data"

  Scenario: User sees privacy notice page
    Given I am on the home page
    When I press "Privacy Notice" footer link
    Then I should see "Drive in a Clean Air Zone"
      And I should see "Check if you’ll be charged to drive in a Clean Air Zone "

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
