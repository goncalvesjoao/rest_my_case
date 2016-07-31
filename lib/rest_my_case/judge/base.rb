module RestMyCase
  module Judge
    class Base
      def initialize(trial_case)
        @trial_case = trial_case
        @performed_use_cases = []
        @use_case_that_aborted = nil
      end

      def determine_the_sentence
        run_setup_methods
        run_perform_methods
        run_rollback_methods
        run_final_methods

        @trial_case.should_abort = !@use_case_that_aborted.nil?
      end

      protected ######################## PROTECTED #############################

      def run_setup_methods
        @trial_case.use_cases.each do |use_case|
          break if method_aborts?(:setup, use_case)
        end
      end

      def run_perform_methods
        validate_context_aborts?(@trial_case.defendant_child)

        @trial_case.use_cases.each do |use_case|
          next if use_case.options[:should_skip] || @use_case_that_aborted

          validate_context_aborts?(use_case)

          @performed_use_cases.push use_case

          method_aborts?(:perform, use_case)
        end
      end

      def run_rollback_methods
        return nil unless @use_case_that_aborted

        @performed_use_cases.reverse_each do |use_case|
          method_aborts?(:rollback, use_case)
        end
      end

      def run_final_methods
        @trial_case.use_cases.each do |use_case|
          method_aborts?(:final, use_case)
        end
      end

      private ########################### PRIVATE ##############################

      def validate_context_aborts?(use_case)
        should_abort_before = use_case.options[:should_abort]

        use_case.validate_context

        if !should_abort_before && use_case.options[:should_abort]
          @use_case_that_aborted = use_case
        end
      rescue Errors::Abort
        @use_case_that_aborted = use_case
      end

      def method_aborts?(method_name, use_case)
        use_case.send(method_name)

        use_case.options[:should_abort] && @use_case_that_aborted = use_case
      rescue Errors::Skip
        false
      rescue Errors::Abort
        @use_case_that_aborted = use_case
      end
    end
  end
end
