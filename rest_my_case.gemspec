# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest_my_case/version'

Gem::Specification.new do |spec|
  spec.name          = "rest_my_case"
  spec.version       = RestMyCase::VERSION
  spec.authors       = ["goncalvesjoao"]
  spec.email         = ["goncalves.joao@gmail.com"]
  spec.summary       = %q{Quick and light "The Clean Architecture" use case implementation.}
  spec.description   = %q{Very light Ruby gem with everything you need in a "The Clean Architecture" use case scenario}
  spec.homepage      = "https://github.com/goncalvesjoao/rest_my_case"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
