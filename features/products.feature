Feature: Visiting products and change currency

  Background:
    Given the following taxonomies exist:
      | name        |
      | Brand       |
      | Categories  |
    Given the custom taxons and custom products exist

  Scenario: show page
    When I go to the home page
    When change currency to "usd"
    When I click first link from selector "ul.product-listing a"
    Then I should see "$17.99"
    When change currency to "rub"
    When I click first link from selector "ul.product-listing a"
    Then I should see "494.76 руб."

  Scenario: make order and change currency between each step
    When I go to the home page
    And I click first link from selector "ul.product-listing a"
    And push "add to cart"
    When click checkout
    When I fill in "order_email" with "test@test.com"
    And I press Continue
    And I fill shipping address with correct data
    And I fill billing address with correct data
    And I press Save and Continue
    And I choose "UPS Ground" as shipping method
    And I enter valid credit card details
    Then I should see "630"
    Then show page
