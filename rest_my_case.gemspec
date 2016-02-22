# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest_my_case/version'

Gem::Specification.new do |gem|
  gem.name          = 'rest_my_case'
  gem.version       = RestMyCase::VERSION
  gem.authors       = ['goncalvesjoao']
  gem.email         = ['goncalves.joao@gmail.com']
  gem.summary       = %q{Quick and light "The Clean Architecture" use case implementation.}
  gem.description   = %q{Very light Ruby gem with everything you need in a "The Clean Architecture" use case scenario}
  gem.homepage      = 'https://github.com/goncalvesjoao/rest_my_case'
  gem.license       = 'MIT'

  gem.files         = `git ls-files -z`.split("\x0")
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'compel', '~> 0.3'

  gem.add_development_dependency 'pry', '~> 0.10'
  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 3.2'
  gem.add_development_dependency 'rubocop', '~> 0.30'
  gem.add_development_dependency 'simplecov', '~> 0.9'
  gem.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
end
