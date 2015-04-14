require "rest_my_case/defense_attorney"
require "rest_my_case/judges/base"

module RestMyCase

  class Base

    extend Configuration::Shared

    def self.depends(*use_cases)
      dependencies.push *use_cases
    end

    def self.dependencies
      @dependencies ||= []
    end

    def self.perform(attributes = {})
      new_trial_case = DefenseAttorney.new(self, attributes).build_trial_case

      Judges::Base.new(trial_case).execute_the_sentence
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

    attr_reader :context, :should_abort, :should_skip

    def initialize(context)
      @context      = context
      @should_skip  = false
      @should_abort = false
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
      @should_abort = true
    end

    def abort!
      abort && raise(Errors::Abort)
    end

    def skip
      @should_skip = true
    end

    def skip!
      skip && raise(Errors::Skip)
    end

  end

end
