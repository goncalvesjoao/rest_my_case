module RestMyCase
  module Validator

    class Base < RestMyCase::Base

      extend ClassMethods

      self.silence_dependencies_abort = true

      extend AccusationAttorneys::HelperMethods

      def target_name
        self.class.target_name
      end

      def target
        respond_to?(target_name) ? send(target_name) : context.send(target_name)
      end

      def perform
        targets = [*target]

        skip! if targets.empty?

        if target.nil?
          error('no target to validate!')
        else
          error('unprocessable_entity') unless all_validations_green? targets
        end
      end

      protected ######################## PROTECTED #############################

      def all_validations_green?(targets)
        targets.map do |object_to_validate|
          if Helpers.marked_for_destruction?(object_to_validate)
            true
          else
            extend_errors_and_run_validations(object_to_validate)

            object_to_validate.errors.empty?
          end
        end.all?
      end

      private ########################### PRIVATE ##############################

      def extend_errors_and_run_validations(object_to_validate)
        extend_errors_if_necessary object_to_validate

        object_to_validate.errors.clear if self.class.clear_errors

        self.class.validators.values.flatten.uniq.each do |validator|
          next if validator_condition_fails(validator, object_to_validate)

          validator.base = self

          validator.validate object_to_validate
        end
      end

      def extend_errors_if_necessary(object_to_validate)
        return true if object_to_validate.respond_to?(:errors)

        object_to_validate.instance_eval do
          def errors
            @errors ||= Errors.new(self)
          end
        end
      end

      def validator_condition_fails(validator, object_to_validate)
        return false unless validator.options.key?(:if)

        !Helpers.call_proc_or_method \
          self, validator.options[:if], object_to_validate
      end

    end

  end
end
