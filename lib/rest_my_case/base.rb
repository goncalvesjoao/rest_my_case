module RestMyCase

  class Base

    extend Config::Base

    def self.depends(*use_cases)
      dependencies.push *use_cases
    end

    def self.dependencies
      @dependencies ||= []
    end

    def self.perform(attributes = {})
      trial_case = TrialCase::Base.new self, attributes

      DefenseAttorney::Base.new(trial_case).build_case_for_the_defendant
      Judge::Base.new(trial_case).execute_the_sentence

      trial_case.context
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
      return false unless dependent_use_case

      RestMyCase.get_config :silence_dependencies_abort, dependent_use_case.class
    end

  end

end
