Feature: Start and stop

  In order to start and stop a background daemon
  As a funky user
  I want foreground to start and stop that background daemon

  Scenario: Start and stop sample daemon
    When I run the sample daemon via foreground
    Then the sample daemon should run

    When I kill foreground
    And I run `sleep 1`
    Then foreground should not run
    And the sample daemon should not run
    And the sample daemon should have received a TERM signal
