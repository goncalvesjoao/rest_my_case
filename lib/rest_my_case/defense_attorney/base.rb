module RestMyCase
  module DefenseAttorney

    class Base

      def initialize(trial_case)
        @trial_case = trial_case
      end

      def build_case_for_the_defendant
        @trial_case.use_cases =
          @trial_case.use_case_classes.map do |use_case_class|
            all_dependencies(use_case_class)
          end.flatten
      end

      protected ######################## PROTECTED #############################

      def all_dependencies(use_case_class)
        return [] if use_case_class == @trial_case.last_ancestor

        all_dependencies(use_case_class.superclass) |
          dependencies_including_itself(use_case_class, @trial_case.defendant)
      end

      private ########################### PRIVATE ##############################

      def dependencies_including_itself(use_case_class, dependent_use_case)
        use_case = use_case_class.new(@trial_case.context, dependent_use_case)

        dependencies(use_case).push use_case
      end

      def dependencies(use_case)
        use_case.class.dependencies.map do |dependency|
          dependencies_including_itself dependency, use_case
        end
      end

    end

  end
end
