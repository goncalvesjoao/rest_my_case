module RestMyCase
  module Context
    module Status

      class Status

        attr_reader :current

        def initialize
          @current = 'ok'
        end

        def method_missing(method, *args, &block)
          matcher = ::RestMyCase::Context::Status::Matcher.new(method)

          if matcher.match_as_setter?
            @current = matcher.status
          elsif matcher.match_as_question?
            @current == matcher.status
          else
            super
          end
        end

        def respond_to?(method, _include_all = false)
          matcher = ::RestMyCase::Context::Status::Matcher.new(method)

          matcher.match? || super
        end

      end

    end
  end
end
