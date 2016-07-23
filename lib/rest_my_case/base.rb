module RestMyCase

  class Base

    extend Config::Base

    def self.trial_court
      @trial_court ||= Trial::Court.new \
        Judge::Base, DefenseAttorney::Base, RestMyCase::Base, Context::Base
    end

    def self.required_context(*schema)
      @required_context_schema = schema

      if schema.length == 1 && (schema[0].is_a?(Hash) || schema[0].is_a?(Array))
        @required_context_schema = schema[0]
      end

      @required_context_schema.each { |context_key| context_reader context_key }
    end

    def self.required_context_schema
      @required_context_schema ||= {}
    end

    def self.depends(*use_case_classes)
      dependencies.concat(use_case_classes)
    end

    def self.dependencies
      @dependencies ||= []
    end

    def self.perform(attributes = nil)
      attributes ||= {}

      unless attributes.respond_to?(:to_hash)
        raise ArgumentError, 'Must respond_to method #to_hash'
      end

      trial_court.execute([self], attributes.to_hash).context
    end

    def self.context_accessor(*methods)
      context_writer(*methods)
      context_reader(*methods)
    end

    def self.context_writer(*methods)
      methods.each do |method|
        define_method("#{method}=") { |value| context.send "#{method}=", value }
      end
    end

    def self.context_reader(*methods)
      methods.each { |method| define_method(method) { context.send(method) } }
    end

    ######################## INSTANCE METHODS BELLOW ###########################

    attr_reader :context, :options

    def initialize(context, dependent_use_case = nil)
      @context = context
      @options = { dependent_use_case: dependent_use_case }

      return unless dependent_use_case

      @options[:silent_abort] = RestMyCase.get_config \
        :silence_dependencies_abort, dependent_use_case.class
    end

    def setup; end

    def perform; end

    def rollback; end

    def final; end

    def invoke(*use_case_classes)
      self.class.trial_court.execute(use_case_classes, context.to_hash).context
    end

    def invoke!(*use_case_classes)
      trial_case = self.class.trial_court.execute(use_case_classes, context)

      abort! if trial_case.aborted

      trial_case.context
    end

    def abort
      if options[:silent_abort]
        options[:dependent_use_case].abort
      else
        options[:should_abort] = true
      end
    end

    def abort!
      abort && raise(Errors::Abort)
    end

    def error(error_message = '')
      error_data = \
        error_message.is_a?(Hash) ? error_message : { message: error_message }

      error_data[:class_name] = self.class.name

      abort && context.errors.add(error_data)
    end

    def error!(error_data = '')
      error(error_data) && raise(Errors::Abort)
    end

    def skip
      options[:should_skip] = true
    end

    def skip!
      skip && raise(Errors::Skip)
    end

    def validate_context(schema = self.class.required_context_schema)
      errors = context.validate_schema(schema)

      error(context_errors: errors, message: 'invalid context') if errors

      Helpers.blank? errors
    end

    def validate_context!(schema = self.class.required_context)
      validate_context(schema) && raise(Errors::Abort)
    end

  end

end
