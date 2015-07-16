module RestMyCase
  module AccusationAttorneys

    # I DO NOT CLAIM OWNERSHIP OF THIS CODE, THIS CODE WAS TAKEN
    # FROM "ActiveModel" GEM AND ADAPTED TO RUN WITHOUT "ActiveSupport"
    # ORIGINAL SOURCE FILE: ActiveModel::EachValidator

    class Each < Base

      attr_reader :attributes

      def initialize(options)
        @attributes = Array(options.delete(:attributes))
        fail ArgumentError, ":attributes cannot be blank" if @attributes.empty?
        super
        check_validity!
      end

      def validate(record)
        attributes.each do |attribute|
          value = record.respond_to?(attribute) ? record.send(attribute) : nil
          next if (value.nil? && options[:allow_nil]) || (Helpers.blank?(value) && options[:allow_blank])
          validate_each(record, attribute, value)
        end
      end

      # Override this method in subclasses with the validation logic, adding
      # errors to the records +errors+ array where necessary.
      def validate_each(record, attribute, value)
        fail NotImplementedError, "Subclasses must implement a validate_each(record, attribute, value) method"
      end

      def check_validity!; end

    end

  end
end
