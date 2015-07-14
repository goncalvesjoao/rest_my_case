module RestMyCase
  module Errors

    class Base < StandardError; end

  end
end

require 'rest_my_case/errors/abort'
require 'rest_my_case/errors/skip'
