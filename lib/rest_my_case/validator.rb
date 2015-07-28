module RestMyCase

  class Validator < Base

    module ClassMethods

      attr_writer :validators

      def trial_court
        @trial_court ||= Trial::Court.new \
          Judge::Base, DefenseAttorney::Base, Validator, Context::Base
      end

      def target_options
        @target_options || Helpers.super_method(self, :target_options)
      end

      def target(target_name, target_options = {})
        @target_options = target_options || {}
        @target_options[:name] = target_name
      end

      def validators
        @validators ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def validate(*args, &block)
        validators[nil] << AccusationAttorneys::Custom.new(args, &block)
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
        validator.attributes.each do |attribute|
          validators[attribute.to_sym] << validator
        end
      end

      # Copy validators on inheritance.
      def inherited(base)
        dup = validators.dup
        base.validators = dup.each { |k, v| dup[k] = v.dup }
        super
      end

    end

    ######################## INSTANCE METHODS BELLOW ###########################

    extend ClassMethods

    self.silence_dependencies_abort = true

    extend AccusationAttorneys::HelperMethods

    def target_options
      self.class.target_options || {}
    end

    def parent_target
      @parent_target ||=
        target_options[:in] ? get_target(target_options[:in]) : nil
    end

    def target
      return nil if target_options[:name].nil?

      if parent_target
        extend_errors_if_necessary(parent_target)

        parent_target.send(target_options[:name])
      else
        get_target(target_options[:name])
      end
    end

    def perform
      targets = [*target]

      return if Helpers.blank?(targets) || all_validations_green?(targets)

      if parent_target
        parent_target.errors.add(target_options[:name], :invalid)
      end

      error('unprocessable_entity')
    end

    protected ######################## PROTECTED ###############################

    def get_target(method)
      respond_to?(method) ? send(method) : context.send(method)
    end

    def all_validations_green?(targets)
      targets.map do |object_to_validate|
        extend_errors_if_necessary(object_to_validate)

        if Helpers.marked_for_destruction?(object_to_validate)
          true
        else
          run_validations(object_to_validate)

          object_to_validate.errors.empty?
        end
      end.all?
    end

    private ########################### PRIVATE ################################

    def run_validations(object_to_validate)
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
          @errors ||= AccusationAttorneys::Errors.new(self)
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
