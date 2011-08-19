Feature: Manage drivers
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Background:
    Given I read in English

  Scenario: Register new driver
    Given I am on the new tengine_core_driver page
    When I fill in "Name" with "name 1"
    And I fill in "Version" with "version 1"
    And I uncheck "Enabled"
    And I press "Create"
    Then I should see "name 1"
    And I should see "version 1"
    And I should see "false"

  Scenario: Delete driver
    Given the following drivers:
      |name|version|enabled|
      |name 1|version 1|false|
      |name 2|version 2|true|
      |name 3|version 3|false|
      |name 4|version 4|true|
    When I delete the 3rd driver
    Then I should see the following drivers:
      |Name|Version|Enabled|
      |name 1|version 1|false|
      |name 2|version 2|true|
      |name 4|version 4|true|
