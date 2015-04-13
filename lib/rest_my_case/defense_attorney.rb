require "rest_my_case/context"

module RestMyCase

  module DefenseAttorney

    def self.build_use_cases_for_the(defendant, attributes)
      shared_context = Context.new attributes

      dependencies(defendant).map do |use_case|
        use_case.new(shared_context)
      end
    end

    protected ###################### PROTECTED #########################

    def self.dependencies(use_case)
      return [] unless use_case.respond_to?(:dependencies)

      if parent_dependencies_first?(use_case)
        dependencies(use_case.superclass) | use_case.dependencies
      else
        use_case.dependencies | dependencies(use_case.superclass)
      end
    end

    def self.parent_dependencies_first?(use_case)
      # use_case.parent_dependencies_first ||
      RestMyCase.configuration.parent_dependencies_first
    end

  end

end
