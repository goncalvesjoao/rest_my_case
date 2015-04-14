require "rest_my_case/context"

module RestMyCase

  class DefenseAttorney

    def self.build_trial_cases(defendant, attributes)
      self.new(attributes).all_dependencies(defendant)
    end

    def initialize(attributes)
      unless attributes.respond_to?(:to_hash)
        raise ArgumentError.new('Must respond_to method #to_hash')
      end

      @shared_context = Context.new attributes.to_hash
    end

    def all_dependencies(use_case, options = {})
      return [] unless use_case.respond_to?(:dependencies)

      parent_dependencies = all_dependencies(use_case.superclass, options)

      if RestMyCase.get_config(:parent_dependencies_first, use_case)
        parent_dependencies | deep_dependencies(use_case, options)
      else
        deep_dependencies(use_case, options) | parent_dependencies
      end
    end

    protected ###################### PROTECTED #########################

    def deep_dependencies(use_case, options)
      options           = build_options(use_case, options)
      deep_dependencies = []

      use_case.dependencies.each do |dependency|
        deep_dependencies.push *all_dependencies(dependency, options)
      end

      include_current_use_case(deep_dependencies, use_case, options)
    end

    private ####################### PRIVATE ###########################

    def build_options(use_case, options)
      unless use_case.silence_dependencies_abort.nil?
        options[:silent_abort] = use_case.silence_dependencies_abort
      end

      options
    end

    def include_current_use_case(dependencies, use_case, options)
      return dependencies unless use_case.superclass.respond_to?(:dependencies)

      append_method =
        RestMyCase.get_config(:dependencies_first, use_case) ? :push : :unshift

      dependencies.send(append_method, use_case.new(@shared_context, options))
    end

  end

end
