module RestMyCase
  module Errors
    Base = Class.new(StandardError)
  end
end

require 'rest_my_case/errors/abort'
require 'rest_my_case/errors/skip'
