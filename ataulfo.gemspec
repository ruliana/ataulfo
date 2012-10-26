# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ataulfo/version'

Gem::Specification.new do |gem|
  gem.name          = "ataulfo"
  gem.version       = Ataulfo::VERSION
  gem.authors       = ['Ronie Uliana']
  gem.email         = ['ronie.uliana@gmail.com']
  gem.description   = %q{Pattern Matching for Ruby (objects only)}
  gem.summary       = %q{A DSL for pattern matching over object in Ruby.}
  gem.homepage      = 'https://github.com/ruliana/ataulfo'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w[lib]

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'guard-rspec'
  gem.add_development_dependency 'rb-inotify'
end
