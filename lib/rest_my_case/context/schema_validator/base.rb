module RestMyCase
  module Context
    module SchemaValidator
      class Base
        def initialize(context)
          @context = context
        end

        def validate(schema)
          errors = {}

          schema.each do |required_attribute|
            if @context.send(required_attribute).nil?
              errors[required_attribute] = 'is required'
            end
          end

          Helpers.blank?(errors) ? nil : errors
        end
      end
    end
  end
end
