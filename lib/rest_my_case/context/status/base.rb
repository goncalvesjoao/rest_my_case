module RestMyCase
  module Context
    module Status

      class Base < Context::Base

        def initialize(*args)
          super(*args)

          @status = ::RestMyCase::Context::Status::Status.new
        end

        def status
          @status
        end

        def status=(val)
          raise 'status is a reserved keyword which cannot be set'
        end

        alias :success? :valid?

      end

    end
  end
end
