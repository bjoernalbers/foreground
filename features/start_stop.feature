Feature: Start and stop

  In order to start and stop a background daemon
  As a funky user
  I want foreground to start and stop that background daemon

  Scenario: Run sample daemon via foreground
    When I run the sample daemon via foreground
    Then foreground should run
    And the sample daemon should run

  Scenario Outline: Kill sample daemon via foreground
    Given I run the sample daemon via foreground
    When I send foreground a <signal> signal
    And I run `sleep 1`
    Then foreground should not run
    And the sample daemon should not run
    And the sample daemon should have received a TERM signal

    Examples:
      | signal | run_or_not |
      | TERM   | not run    |
      | INT    | not run    |
