Feature: Sample daemon

  In order to test foreground properly
  As an BDD guy
  I want a sample daemon along with cucumber steps

  Scenario: Start and stop sample daemon
    When I run the sample daemon
    Then the sample daemon should run
    And a file named "/tmp/foreground_sample_daemon.pid" should exist
    And the file "/tmp/foreground_sample_daemon.log" should contain exactly:
      """
      Daemon started...

      """

    When I kill the sample daemon
    Then the sample daemon should not run
    And a file named "/tmp/foreground_sample_daemon.pid" should not exist
    But a file named "/tmp/foreground_sample_daemon.log" should exist

  Scenario: Run only one sample daemon at once
    When I run the sample daemon
    And I run the sample daemon
    Then the sample daemon should run

  Scenario Outline: Log received signals
    Given I run the sample daemon
    When I send the sample daemon a <signal> signal
    Then the sample daemon should <run_or_not>
    And the file "/tmp/foreground_sample_daemon.log" should contain "received <signal> signal"
    And the file "/tmp/foreground_sample_daemon.log" should contain "Daemon <message>."

    Examples:
      | signal | run_or_not | message   |
      | TERM   | not run    | stopped   |
      | INT    | not run    | stopped   |
      | QUIT   | not run    | stopped   |
      | HUP    | run        | refreshed |

  Scenario: Don't mess up the system with running sample daemons
    Then the sample daemon should not run
    And a file named "/tmp/foreground_sample_daemon.pid" should not exist
