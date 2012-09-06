Feature: Sample daemon

  In order to test foreground properly
  As an BDD guy
  I want a sample daemon along with cucumber steps

  Scenario: Run sample daemon
    When I successfully run `foreground_sample_daemon`
    Then the sample daemon should run
    And a file named "/tmp/foreground_sample_daemon.pid" should exist

  Scenario: Run only one sample daemon at once
    When I successfully run `foreground_sample_daemon`
    And I successfully run `foreground_sample_daemon`
    Then the sample daemon should run

  Scenario: Don't mess up the system with running sample daemons
    Then the sample daemon should not run
    And a file named "/tmp/foreground_sample_daemon.pid" should not exist
