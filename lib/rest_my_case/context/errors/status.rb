module RestMyCase
  module Context
    module Errors

      class Status < Base

        attr_reader :last_known_error

        def add(error)
          super

          @context.status.send("#{error[:status]}!")

          @last_known_error = error
        end

      end

    end
  end
end
