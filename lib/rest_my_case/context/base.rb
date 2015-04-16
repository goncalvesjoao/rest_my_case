module RestMyCase
  module Context

    class Base < OpenStruct

      alias :attributes :marshal_dump

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

      alias :ok? :valid?

    end

  end
end
