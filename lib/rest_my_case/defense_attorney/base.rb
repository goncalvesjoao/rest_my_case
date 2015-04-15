module RestMyCase
  module DefenseAttorney

    class Base

      def initialize(trial_case)
        @trial_case = trial_case
      end

      def build_case_for_the_defendant
        @trial_case.use_cases =
          @trial_case.defendant.use_cases.map do |use_case_class|
            all_dependencies(use_case_class)
          end.flatten
      end

      protected ###################### PROTECTED #########################

      def all_dependencies(use_case_class)
        return [] unless use_case_class.respond_to? :dependencies

        all_dependencies(use_case_class.superclass) |
        dependencies_including_itself_last(use_case_class, nil)
      end

      private ######################## PRIVATE ##########################

      def dependencies_including_itself_last(use_case_class, dependent_use_case)
        return [] unless use_case_class.superclass.respond_to? :dependencies

        use_case = use_case_class.new(@trial_case.context, dependent_use_case)

        dependencies(use_case).push use_case
      end

      def dependencies(use_case)
        use_case.class.dependencies.map do |dependency|
          dependencies_including_itself_last dependency, use_case
        end
      end

    end

  end
end
