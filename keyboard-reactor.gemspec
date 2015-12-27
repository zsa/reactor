# -*- encoding: utf-8 -*-
require File.expand_path('../lib/keyboard_reactor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.version       = KeyboardReactor::VERSION
  gem.authors       = ['Seth Herr']
  gem.description   = gem.summary = 'Keyboard firmware generator using qmk_firmware - from Fusion JSON'
  gem.homepage      = 'https://github.com/ErgoDox-EZ/reactor'
  gem.license       = 'MIT'
  gem.executables   = ['keyboard_reactor']
  gem.files         = `git ls-files README.md Rakefile LICENSE.md lib bin`.split("\n")
  gem.name          = 'keyboard_reactor'
  gem.require_paths = ['lib']
  gem.add_dependency 'multi_json', '~> 1.11', '>= 1.11.2'
  gem.add_dependency 'rake-compiler', '~> 0.9', '>= 0.9.5'
  gem.add_development_dependency 'rake', '~> 10.4'
  gem.add_development_dependency 'rspec', '>= 3.3', '< 4.0'
end
