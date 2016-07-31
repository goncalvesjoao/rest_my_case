# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest_my_case/version'

Gem::Specification.new do |gem|
  gem.name          = 'rest_my_case'
  gem.version       = RestMyCase::VERSION
  gem.authors       = ['João Gonçalves']
  gem.email         = ['goncalves.joao@gmail.com']
  gem.summary       = 'Light "The Clean Architecture" use case implementation.'
  gem.description   = 'Light Ruby gem with everything you need in a' \
                      ' "The Clean Architecture" use case scenario'
  gem.homepage      = 'https://github.com/goncalvesjoao/rest_my_case'
  gem.license       = 'MIT'

  gem.files         = Dir['README.md', 'lib/**/*']
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'pry', '0.10.3'
  gem.add_development_dependency 'rake', '11.2.2'
  gem.add_development_dependency 'json', '1.8.3'
  gem.add_development_dependency 'rspec', '3.4.0'
  gem.add_development_dependency 'rubocop', '0.37.2'
  gem.add_development_dependency 'simplecov', '0.11.2'
  gem.add_development_dependency 'codeclimate-test-reporter', '0.4.8'

  gem.add_dependency 'object_attorney', '~> 3.0'
end
