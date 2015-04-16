module RestMyCase
  module Context

    class Base < OpenStruct

      alias_method :attributes, :marshal_dump

      include ActiveModel::Serialization if defined?(ActiveModel)

      def to_hash
        Marshal.load Marshal.dump(attributes)
      end

      def errors
        @errors ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def valid?
        errors.empty?
      end

      alias_method :ok?, :valid?

    end

  end
end
