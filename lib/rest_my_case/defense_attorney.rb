require "rest_my_case/context"

module RestMyCase

  class DefenseAttorney

    def initialize(starting_point_use_case, attributes)
      unless attributes.respond_to?(:to_hash)
        raise ArgumentError.new('Must respond_to method #to_hash')
      end

      @shared_context          = Context.new attributes.to_hash
      @starting_point_use_case = starting_point_use_case
    end

    def build_trial_case
      all_dependencies(@starting_point_use_case).map do |use_case|
        use_case.new(@shared_context)
      end
    end

    protected ###################### PROTECTED #########################

    def all_dependencies(use_case)
      return [] unless use_case.respond_to?(:dependencies)

      if RestMyCase.get_config(:parent_dependencies_first, use_case)
        all_dependencies(use_case.superclass) | deep_dependencies(use_case)
      else
        deep_dependencies(use_case) | all_dependencies(use_case.superclass)
      end
    end

    def deep_dependencies(use_case)
      deep_dependencies = []

      use_case.dependencies.each do |use_case|
        deep_dependencies.push *all_dependencies(use_case)
      end

      include_current_use_case(deep_dependencies, use_case)
    end

    private ####################### PRIVATE ###########################

    def include_current_use_case(dependencies, use_case)
      return dependencies unless use_case.superclass.respond_to?(:dependencies)

      if RestMyCase.get_config(:dependencies_first, use_case)
        dependencies.push(use_case)
      else
        dependencies.unshift(use_case)
      end
    end

  end

end
