def sample_daemons
  proclist = `/bin/ps -A -o pid,command`
  proclist.to_a.grep(%r{^\s*\d+\s+ruby\s+.*foreground_sample_daemon$}) { |l| l[/^\s*(\d+)\s+/,1].to_i }
end

After do
  sample_daemons.each { |pid| system("kill #{pid}") }
end

Then /^the sample daemon should run$/ do
  steps %q{
    Then 1 sample daemon should run
  }
end

Then /^no sample daemon should run$/ do
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
