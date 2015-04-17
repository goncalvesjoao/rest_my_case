module RestMyCase
  module AccusationAttorneys

    class Base

      attr_accessor :base

      attr_reader :options

      def initialize(options = {})
        @options = Helpers.except(options, :class).freeze
      end

      # Override this method in subclasses with validation logic, adding errors
      # to the records +errors+ array where necessary.
      def validate(record)
        fail NotImplementedError, "Subclasses must implement a validate(record) method."
      end

    end

  end
end
