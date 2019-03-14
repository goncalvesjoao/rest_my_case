# frozen_string_literal: true

module RestMyCase
  module Context
    module Errors
      class Base < Array
        def initialize(context)
          super()

          @context = context
        end

        def add(error)
          push(error)
        end
      end
    end
  end
end
