module RestMyCase
  module Helpers
    module_function

    def blank?(object)
      if object.is_a?(String)
        object !~ /[^[:space:]]/
      else
        object.respond_to?(:empty?) ? object.empty? : !object
      end
    end
  end
end
