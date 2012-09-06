# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'foreground/version'

Gem::Specification.new do |gem|
  gem.name          = 'foreground'
  gem.version       = Foreground::VERSION
  gem.authors       = ["Bjo\314\210rn Albers"]
  gem.email         = ['bjoernalbers@googlemail.com']
  gem.description   = 'Control daemonized background processes with launchd.'
  gem.summary       = "#{gem.name}-#{gem.version}"
  gem.homepage      = 'https://github.com/bjoernalbers/foreground'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/foreground}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
