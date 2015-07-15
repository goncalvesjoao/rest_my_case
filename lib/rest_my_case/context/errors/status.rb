module RestMyCase
  module Context
    module Errors

      class Status < Base

        def add(error, message)
          super

          status = message.to_s.split(' - ')[0]

          @context.status.send("#{status}!")
        end

      end

    end
  end
end
