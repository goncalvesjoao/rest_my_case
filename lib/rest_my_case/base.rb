module RestMyCase

  class Base

    extend Config::Base

    def self.trial_court
      @trial_court ||= Trial::Court.new \
        Judge::Base, DefenseAttorney::Base, RestMyCase::Base
    end

    def self.depends(*use_case_classes)
      dependencies.push(*use_case_classes)
    end

    def self.dependencies
      @dependencies ||= []
    end

    def self.perform(attributes = nil)
      attributes ||= {}

      unless attributes.respond_to?(:to_hash)
        fail ArgumentError, 'Must respond_to method #to_hash'
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

    attr_reader :context, :dependent_use_case, :options

    def initialize(context, dependent_use_case = nil)
      @options            = {}
      @context            = context
      @dependent_use_case = dependent_use_case
    end

    def setup;  end

    def perform;  end

    def rollback; end

    def final; end

    def invoke(*use_case_classes)
      trial_court.execute(use_case_classes, context.to_hash).context
    end

    def invoke!(*use_case_classes)
      trial_court.execute(use_case_classes, context).tap do |trial_case|
        abort if trial_case.aborted
      end.context
    end

    def abort
      silent_abort? ? dependent_use_case.abort : (options[:should_abort] = true)
    end

    def abort!
      abort && fail(Errors::Abort)
    end

    def error(message = '')
      abort && context.errors[self.class.name].push(message)
    end

    def error!(message = '')
      error(message) && fail(Errors::Abort)
    end

    def skip
      options[:should_skip] = true
    end

    def skip!
      skip && fail(Errors::Skip)
    end

    protected ######################## PROTECTED ###############################

    def trial_court
      self.class.trial_court
    end

    def silent_abort?
      return false if dependent_use_case.nil?

      RestMyCase.get_config \
        :silence_dependencies_abort, dependent_use_case.class
    end

  end

end
