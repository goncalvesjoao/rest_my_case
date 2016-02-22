require 'compel'

module RestMyCase
  module Context
    module SchemaValidator

      class Base

        def initialize(context)
          @context = context
        end

        def validate(schema)
          result = ::Compel.run(@context, build_schema(schema))

          result.valid? ? nil : result.errors
        end

        protected ###################### PROTECTED #############################

        def build_schema(schema)
          ::Compel.hash.keys \
            schema.is_a?(Hash) ? schema : all_attributes_required(schema)
        end

        def all_attributes_required(schema)
          {}.tap do |new_schema|
            schema.each { |key| new_schema[key] = Compel.any.required }
          end
        end

      end

    end
  end
end
