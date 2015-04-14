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
      attorney   = DefenseAttorney::Base.new trial_case
      judge      = Judge::Base.new trial_case

      attorney.build_case_for_the_defendant

      judge.execute_the_sentence

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

    attr_reader :context, :options

    def initialize(context, options = {})
      @context = context
      @options = options
    end

    def setup;  end

    def perform;  end

    def rollback; end

    def final; end

    def fail(message = '')
      abort && @context.errors[self.class.name].push(message)
    end

    def fail!(message = '')
      fail(message) && raise(Errors::Abort)
    end

    def abort
      options[:should_abort] = true
    end

    def abort!
      abort && raise(Errors::Abort)
    end

    def skip
      options[:should_skip] = true
    end

    def skip!
      skip && raise(Errors::Skip)
    end

  end

end
