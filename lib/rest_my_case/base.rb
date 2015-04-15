module RestMyCase

  class Base

    extend Config::Base

    TRIAL_COURT = Trial::Court.new Judge::Base, DefenseAttorney::Base

    def self.depends(*use_cases)
      dependencies.push *use_cases
    end

    def self.dependencies
      @dependencies ||= []
    end

    def self.perform(attributes = {})
      TRIAL_COURT.execute([self], attributes)
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

    ##################### INSTANCE METHODS BELLOW ###################

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

    def abort
      silent_abort? ? dependent_use_case.abort : (options[:should_abort] = true)
    end

    def abort!
      abort && raise(Errors::Abort)
    end

    def fail(message = '')
      abort && context.errors[self.class.name].push(message)
    end

    def fail!(message = '')
      fail(message) && raise(Errors::Abort)
    end

    def skip
      options[:should_skip] = true
    end

    def skip!
      skip && raise(Errors::Skip)
    end

    protected #################### PROTECTED ####################

    def silent_abort?
      return false if dependent_use_case.nil?

      RestMyCase.get_config :silence_dependencies_abort, dependent_use_case.class
    end

  end

end
