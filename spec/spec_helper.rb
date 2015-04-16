require "codeclimate-test-reporter"

CodeClimate::TestReporter.start

require "simplecov"

SimpleCov.start do
  root("lib/")
  coverage_dir("../tmp/coverage/")
end

require 'pry'
require 'rest_my_case'
$: <<  File.expand_path('../', File.dirname(__FILE__))

Dir["./spec/**/support/**/*.rb"].each do |file|
  require file
end

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
