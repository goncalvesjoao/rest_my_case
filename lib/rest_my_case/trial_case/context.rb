module RestMyCase
  module TrialCase

    class Context < OpenStruct

      def errors
        @errors ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def valid?
        errors.empty?
      end

      alias :ok? :valid?

      def serializable_hash(options = nil)
        marshal_dump
      end

      alias :to_hash :serializable_hash

    end

  end
end
