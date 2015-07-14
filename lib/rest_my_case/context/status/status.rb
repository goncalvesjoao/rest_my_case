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

        def to_s
          current.to_s
        end

        def ==(value)
          to_s == value
        end

      end

    end
  end
end
