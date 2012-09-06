def sample_daemons
  proclist = `/bin/ps -A -o pid,command`
  proclist.to_a.grep(%r{^\s*\d+\s+ruby\s+.*foreground_sample_daemon$}) { |l| l[/^\s*(\d+)\s+/,1].to_i }
end

def kill_foreground
  if @foreground
    Process.kill(:TERM, @foreground) unless Process.waitpid(@foreground, Process::WNOHANG)
  end
end

After do
  kill_foreground
  sample_daemons.each { |pid| system("kill #{pid}") }
end

When /^I run the sample daemon via foreground$/ do
  @foreground = fork do
    system('foreground --pid_file /tmp/foreground_sample_daemon.pid foreground_sample_daemon')
  end
end

When /^I kill foreground$/ do
  kill_foreground
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
