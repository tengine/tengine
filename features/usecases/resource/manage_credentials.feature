Feature: Manage credentials
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Background:
    Given I read in English

  Scenario: Register new credential
    Given I am on the new credential page
    And I press "Create"

  Scenario: Delete credential
    Given the following credentials:
      ||
      ||
      ||
      ||
      ||
    When I delete the 3rd credential
    Then I should see the following credentials:
      ||
      ||
      ||
      ||
