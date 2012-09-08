STDOUT.sync = true # for debugging

def sample_daemons
  proclist = `/bin/ps -A -o pid,command`
  proclist.to_a.grep(%r{^\s*\d+\s+ruby\s+.*foreground_sample_daemon$}) { |l| l[/^\s*(\d+)\s+/,1].to_i }
end

def kill_foreground(signal = :TERM)
  if @foreground
    begin
      Process.kill(signal, @foreground)
      Process.waitpid(@foreground)
    rescue Errno::ESRCH, Errno::ECHILD
    end
  end
end

def kill_all_sample_daemons(signal=:TERM)
  sample_daemons.each { |pid| system("kill -#{signal} #{pid}") }
  sleep 1 # Give the process time to say goodbye.
end

After do
  kill_foreground
  kill_all_sample_daemons
end

When /^I run the sample daemon$/ do
  steps %q{
    When I successfully run `foreground_sample_daemon`
  }
end

When /^I run the sample daemon via foreground$/ do
  @foreground = fork do
    exec('foreground', '--pid_file', '/tmp/foreground_sample_daemon.pid', 'foreground_sample_daemon')
  end
end

When /^I kill the sample daemon$/ do
  kill_all_sample_daemons
end

When /^I send the sample daemon a (\w+) signal$/ do |signal|
  kill_all_sample_daemons(signal.to_sym)
end

When /^I kill foreground$/ do
  steps %q{
    When I send foreground a TERM signaf
  }
end

When /^I send foreground a (\w+) signal$/ do |signal|
  sleep 1 # Give foreground some time to setup signal handling... or tests might break.
  kill_foreground(signal)
end

Then /^foreground should run$/ do
  lambda { Process.kill(0, @foreground) }.should_not raise_error(Errno::ESRCH)
end

Then /^foreground should not run$/ do
  unless @foreground
    lambda { Process.kill(0, @foreground) }.should raise_error(Errno::ESRCH),
      "foreground still running with PID #{@foreground}"
  end
end

Then /^the sample daemon should run$/ do
  steps %q{
    Then 1 sample daemon should run
  }
end

Then /^the sample daemon should not run$/ do
  steps %q{
    Then 0 sample daemon should run
  }
end

Then /^(\d+) sample daemons? should run$/ do |expected|
  expected = expected.to_i
  actual = sample_daemons.count
  actual.should eql(expected),
    "Expected #{expected} running sample daemon, but got #{actual} instead!"
end

Then /^the sample daemon should have received a (\w+) signal$/ do |signal|
  steps %Q{
    Then the file "/tmp/foreground_sample_daemon.log" should contain "received #{signal} signal"
  }
end
