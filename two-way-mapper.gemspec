# coding: utf-8

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'two_way_mapper/version'

Gem::Specification.new do |spec|
  spec.name          = 'two-way-mapper'
  spec.version       = TwoWayMapper::VERSION
  spec.authors       = ['Tim Masliuchenko']
  spec.email         = ['insside@gmail.com']
  spec.description   = 'Two way data mapping'
  spec.summary       = 'Two way data mapping'
  spec.homepage      = 'https://github.com/timsly/two-way-mapper'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-its'
end
