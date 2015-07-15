module RestMyCase
  module Context
    module Errors

      class Status < Base

        def add(error, message)
          super

          @context.status.send("#{message}!")
        end

      end

    end
  end
end
