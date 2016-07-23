require 'rest_my_case/context/errors/base'
require 'rest_my_case/context/schema_validator/base'

module RestMyCase
  module Context

    class Base < OpenStruct

      alias attributes marshal_dump

      if defined?(ActiveModel) && defined?(ActiveModel::Serialization)
        include ActiveModel::Serialization
      end

      def self.error_class
        Errors::Base
      end

      def self.schema_validator_class
        SchemaValidator::Base
      end

      def values_at(*keys)
        attributes.values_at(*keys)
      end

      def to_hash
        Marshal.load Marshal.dump(attributes)
      end

      def validate_schema(schema)
        self.class.schema_validator_class.new(self).validate(schema)
      end

      def errors
        @errors ||= self.class.error_class.new(self)
      end

      def valid?
        errors.empty?
      end

      alias ok? valid?

      alias success? ok?

    end

  end
end
