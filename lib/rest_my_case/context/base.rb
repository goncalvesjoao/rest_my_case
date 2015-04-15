module RestMyCase
  module Context

    class Base < OpenStruct

      include ActiveModel::Serialization if defined?(ActiveModel)

      def errors
        @errors ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def valid?
        errors.empty?
      end

      alias :ok? :valid?

      alias :attributes :marshal_dump

      alias :to_hash :attributes

    end

  end
end
