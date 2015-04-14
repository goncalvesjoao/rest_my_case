module RestMyCase
  module Judge

    class Base

      def initialize(trial_case)
        @trial_case            = trial_case
        @performed_use_cases   = []
        @use_case_that_aborted = false
      end

      def execute_the_sentence
        run_setup_methods
        run_perform_methods
        run_rollback_methods
        run_final_methods
      end

      protected #################### PROTECTED ####################

      def run_setup_methods
        @trial_case.use_cases.each do |use_case|
          break if method_setup_has_aborted use_case
        end
      end

      def run_perform_methods
        return nil if @use_case_that_aborted

        @trial_case.use_cases.each do |use_case|
          break if method_perform_has_aborted use_case
        end
      end

      def run_rollback_methods
        return nil unless @use_case_that_aborted

        @performed_use_cases.reverse.each do |use_case|
          run_method(:rollback, use_case)
        end
      end

      def run_final_methods
        @trial_case.use_cases.each { |use_case| run_method(:final, use_case) }
      end

      private #################### PRIVATE ######################

      def method_setup_has_aborted(use_case)
        method_aborts?(:setup, use_case)
      end

      def method_perform_has_aborted(use_case)
        return false if use_case.options[:should_skip]

        @performed_use_cases.push use_case

        method_aborts?(:perform, use_case)
      end

      def method_aborts?(method_name, use_case)
        begin
          run_method(method_name, use_case)

          use_case.options[:should_abort] && @use_case_that_aborted = use_case
        rescue Errors::Skip => exception
          false
        rescue Errors::Abort => exception
          @use_case_that_aborted = use_case
        end
      end

      def run_method(method_name, use_case)
        use_case.send(method_name)
      end

    end

  end
end
