module RestMyCase
  module Validator

    module ClassMethods

      attr_reader :validators, :clear_errors

      def trial_court
        @trial_court ||= Trial::Court.new \
          Judge::Base, DefenseAttorney::Base, RestMyCase::Validator::Base
      end

      def target_name
        @target_name || Helpers.super_method(self, :target_name)
      end

      def target(target_name)
        @target_name = target_name
      end

      def clear_errors!
        @clear_errors = true
      end

      def validators
        @validators ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def validate(*args, &block)
        validators[nil] << CustomValidator.new(args, &block)
      end

      def validates_with(*args, &block)
        options = Helpers.extract_options!(args)

        options[:class] = self

        args.each do |klass|
          store_validators_by_attribute klass.new(options, &block)
        end
      end

      protected ######################## PROTECTED #############################

      def store_validators_by_attribute(validator)
        if validator.respond_to?(:attributes) && !validator.attributes.empty?
          validator.attributes.each do |attribute|
            validators[attribute.to_sym] << validator
          end
        else
          validators[nil] << validator
        end
      end

    end

  end
end
