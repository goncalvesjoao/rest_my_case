module RestMyCase
  module DefenseAttorney

    class Base

      def initialize(trial_case)
        @trial_case = trial_case
      end

      def build_case_for_the_defendant
        @trial_case.use_cases = all_dependencies @trial_case.defendant
      end

      protected ###################### PROTECTED #########################

      def all_dependencies(use_case, dependent_use_case = nil)
        return [] unless use_case.respond_to?(:dependencies)

        all_dependencies(use_case.superclass, dependent_use_case) |
        dependencies_including_itself_last(use_case, dependent_use_case)
      end

      private ######################## PRIVATE ##########################

      def dependencies_including_itself_last(use_case, dependent_use_case)
        deep_dependencies = dependencies(use_case, dependent_use_case)

        if use_case.superclass.respond_to? :dependencies
          deep_dependencies.push \
            use_case.new(@trial_case.context, dependent_use_case)
        end

        deep_dependencies
      end

      def dependencies(use_case, dependent_use_case)
        use_case.dependencies.map do |dependency|
          dependencies_including_itself_last dependency, dependent_use_case
        end.flatten
      end

    end

  end
end
