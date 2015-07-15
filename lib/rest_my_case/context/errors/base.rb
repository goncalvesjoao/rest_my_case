module RestMyCase
  module Context
    module Errors

      class Base < Hash

        def initialize(context)
          super()

          @context = context
        end

        def add(error, message)
          self[error] ||= []

          self[error].push(message)
        end

      end

    end
  end
end
