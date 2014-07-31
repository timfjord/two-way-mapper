# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'two_way_mapper/version'

Gem::Specification.new do |spec|
  spec.name          = "two-way-mapper"
  spec.version       = TwoWayMapper::VERSION
  spec.authors       = ["Tima Maslyuchenko"]
  spec.email         = ["insside@gmail.com"]
  spec.description   = %q{Two way data mapping}
  spec.summary       = %q{Two way data mapping}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler",   "~> 1.3"
  spec.add_development_dependency "rspec",     "~> 3.0"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "rake"
end
