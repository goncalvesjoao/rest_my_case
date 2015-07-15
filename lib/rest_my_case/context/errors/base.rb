module RestMyCase
  module Context
    module Errors

      class Base < Hash

        def initialize(context)
          super()

          @context = context
        end

        def add(class_name, message)
          self[class_name] ||= []

          self[class_name].push(message.to_s)
        end

        def messages
          self.values.flatten
        end

        def full_messages
          self.map do |class_name, messages|
            "#{class_name}: #{messages.join(', ')}"
          end
        end

      end

    end
  end
end
