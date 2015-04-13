require "rest_my_case/defense_attorney"

module RestMyCase
  module Judges

    class Base

      def self.execute_the_sentence(defendant, attributes)
        new_trial = self.new(defendant, attributes)

        new_trial.run_setup_methods
        new_trial.run_perform_methods
        new_trial.run_rollback_methods
        new_trial.run_final_methods
      end

      def initialize(defendant, attributes)
        @use_cases =
          DefenseAttorney.build_use_cases_for_the(defendant, attributes)

        @performed_use_cases   = []
        @use_case_that_aborted = false
      end

      protected #################### PROTECTED ####################

      def run_setup_methods
        @use_cases.each do |use_case|
          break if method_setup_has_aborted use_case
        end
      end

      def run_perform_methods
        return nil if @use_case_that_aborted

        @use_cases.each do |use_case|
          break if method_perform_has_aborted use_case
        end
      end

      def run_rollback_methods
        return nil unless @use_case_that_aborted

        @performed_use_cases.revert.each do |use_case|
          run_method(:rollback, use_case)
        end
      end

      def run_final_methods
        @use_cases.each { |use_case| run_method(:final, use_case) }
      end

      private #################### PRIVATE ######################

      def method_setup_has_aborted(use_case)
        method_aborts?(:setup, use_case)
      end

      def method_perform_has_aborted(use_case)
        return false if use_case.should_skip

        @performed_use_cases.push use_case

        method_aborts?(:perform, use_case)
      end

      def method_aborts?(method_name, use_case)
        begin
          run_method(method_name, use_case)

          use_case.should_abort
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
