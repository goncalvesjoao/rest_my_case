module RestMyCase

  class Base

    def self.depends(*use_cases)
      local_dependencies.push *use_cases
    end

    # List of use case classes that the current class depends on
    def self.local_dependencies
      @local_dependencies ||= []
    end

    # List of use cases that the current class depends on, plus its parent class
    # This list will be used during .perform
    def self.dependencies
      local_dependencies.concat superclass.dependencies
    end

    def self.perform(attributes = {})
      Judge.execute_the_sentence self, Context.new(attributes)
    end

    attr_reader :context, :should_abort, :should_skip

    def initialize(context)
      @context = context

      @should_abort = @should_skip = false
    end

    def before;  end

    def perform;  end

    def rollback; end

    def final; end

    # Calls #abort and populates the context's errors
    def fail(message = '')
      abort

      @context.errors[self.class.name].push message
    end

    # Calls #fail and also prevents the next line of code to be ran
    def fail!(message = '')
      fail message

      raise Errors::Abort
    end

    # Prevents the next use case to be ran and will trigger the rollback process
    def abort
      @should_abort = true
    end

    # Calls #abort and prevents the next line of code to be ran
    def abort!
      abort

      raise Errors::Abort
    end

    # To be used during the #before method:
    #   Prevents the current use case to be
    #   ran (during perform), but not the next ones
    def skip
      @should_skip = true
    end

    # Calls #skip and prevents the next line of code to be ran
    def skip!
      skip

      raise Errors::Skip
    end

  end

end
