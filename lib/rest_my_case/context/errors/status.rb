module RestMyCase
  module Context
    module Errors

      class Status < Base

        attr_reader :last_known_error

        def add(error)
          super

          if error[:status].nil? && error[:message]
            error[:status]  = error[:message]
            error[:message] = nil
          end

          error[:status] = error[:status].to_s

          @context.status.send("#{error[:status]}!")

          @last_known_error = error
        end

      end

    end
  end
end
