require 'rest_my_case/context/errors/status'

module RestMyCase
  module Context
    class Status < Base
      class StatusString < String

        def method_missing(method, *args, &block)
          last_char = method[-1]
          method_name = method[0...-1]

          if last_char == '!'
            replace(method_name)
          elsif last_char == '?'
            self == method_name
          else
            super
          end
        end

      end

      def self.error_class
        Errors::Status
      end

      def status
        @status ||= StatusString.new 'ok'
      end

      def status=(_)
        raise 'status is a reserved keyword which cannot be set'
      end
    end
  end
end
