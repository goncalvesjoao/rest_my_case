module RestMyCase
  module AccusationAttorneys

    # I DO NOT CLAIM OWNERSHIP OF THIS CODE, THIS CODE WAS TAKEN
    # FROM "ActiveModel" GEM AND ADAPTED TO RUN WITHOUT "ActiveSupport"
    # ORIGINAL SOURCE FILE: ActiveModel::Validator

    class Base

      attr_accessor :base

      attr_reader :options

      def initialize(options = {})
        @options = Helpers.except(options, :class).freeze
      end

      # Override this method in subclasses with validation logic, adding errors
      # to the records +errors+ array where necessary.
      def validate(record)
        raise NotImplementedError, "Subclasses must implement a validate(record) method."
      end

    end

  end
end
