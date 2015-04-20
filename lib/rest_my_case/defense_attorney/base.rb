module RestMyCase
  module DefenseAttorney

    class Base

      def initialize(trial_case)
        @trial_case           = trial_case
        @trial_case.use_cases = []
      end

      def build_case_for_the_defendant
        dependencies(@trial_case.defendant_class).map do |dependency|
          gather_all_use_cases dependency, @trial_case.defendant
        end
      end

      protected ######################## PROTECTED #############################

      def gather_all_use_cases(use_case_class, dependent)
        use_case = use_case_class.new(@trial_case.context, dependent)

        dependencies(use_case_class).map do |dependency|
          gather_all_use_cases dependency, use_case
        end

        @trial_case.use_cases.push use_case
      end

      def dependencies(use_case_class)
        return [] if use_case_class == @trial_case.last_ancestor

        if RestMyCase.get_config :parent_dependencies_first, use_case_class
          dependencies(use_case_class.superclass) | use_case_class.dependencies
        else
          use_case_class.dependencies | dependencies(use_case_class.superclass)
        end
      end

    end

  end
end
