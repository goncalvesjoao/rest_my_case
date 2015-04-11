require 'pry'
require "simplecov"
require 'usecasing_validations'

SimpleCov.start do
  root("lib/")
  coverage_dir("../tmp/coverage/")
end

$: <<  File.expand_path('../', File.dirname(__FILE__))

Dir["./spec/**/support/**/*.rb"].each do |file|
  require file
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.mock_framework = :mocha

  config.order = 'random'
end
