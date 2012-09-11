Feature: Watch daemon

  In order to notify launchd about a terminated daemon
  As a funky user
  I want foreground to terminate as well

  Scenario: Terminate when daemon goes down
    Given I run the sample daemon via foreground
    Then foreground should run
    And the sample daemon should run
    Given I run `sleep 2`
    When I kill the sample daemon
    Then foreground should not run
    And the sample daemon should not run
