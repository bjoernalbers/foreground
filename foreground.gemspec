# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foreground/version'

Gem::Specification.new do |gem|
  gem.name          = 'foreground'
  gem.version       = Foreground::VERSION
  gem.authors       = ["Bjo\314\210rn Albers"]
  gem.email         = ['bjoernalbers@googlemail.com']
  gem.description   = 'Control daemonizing background processes with launchd.'
  gem.summary       = "#{gem.name}-#{gem.version}"
  gem.homepage      = 'https://github.com/bjoernalbers/foreground'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/foreground}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'mixlib-cli', '~> 1.2.2'

  gem.add_development_dependency 'aruba', '>= 0.4.11'
  gem.add_development_dependency 'aruba-doubles', '~> 1.2.1'
  gem.add_development_dependency 'guard-cucumber', '>= 0.7.5'
  gem.add_development_dependency 'guard-rspec', '>= 0.5.1'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rb-fsevent', '>= 0.9.0' if RUBY_PLATFORM =~ /darwin/i 
end
