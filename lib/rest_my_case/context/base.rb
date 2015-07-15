module RestMyCase
  module Context

    class Base < OpenStruct

      alias_method :attributes, :marshal_dump

      include ActiveModel::Serialization if defined?(ActiveModel)

      def self.error_class
        Errors::Base
      end

      def to_hash
        Marshal.load Marshal.dump(attributes)
      end

      def errors
        @errors ||= self.class.error_class.new(self)
      end

      def valid?
        errors.empty?
      end

      alias_method :ok?, :valid?

      alias_method :success?, :ok?

    end

  end
end
