require "rest_my_case/defense_attorney"

module RestMyCase

  module Judge

    extend self

    def execute_the_sentence(defendant, context)
      @use_case_that_aborted = false

      @use_cases = DefenseAttorney.build_use_cases_for_the defendant, context

      run_before_methods

      run_perform_methods

      run_rollback_methods

      run_final_methods
    end

    protected #################### PROTECTED ####################

    def run_before_methods
      @use_cases.each do |use_case|
        break if run_method(:before, use_case) == 'abort'
      end
    end

    def run_perform_methods
      return nil if @use_case_that_aborted

      @use_cases.each do |use_case|
        break if run_method(:perform, use_case) == 'abort'
      end
    end

    def run_rollback_methods
      return nil unless @use_case_that_aborted

      # Revert the list, remove all use cases until you find
      # the use_case_that_aborted and run .map(&:rollback)
      # on the remaining elements
    end

    def run_final_methods
      @use_cases.map(&:final)
    end

    private #################### PRIVATE ######################

    def run_method(method_name, use_case)
      begin
        return 'skip' if use_case.should_skip

        use_case.send(method_name)

        use_case.should_abort ? 'abort' : 'ok'
      rescue Errors::Skip => exception
        'skip'
      rescue Errors::Abort => exception
        @use_case_that_aborted = use_case
        'abort'
      end
    end

  end

end
