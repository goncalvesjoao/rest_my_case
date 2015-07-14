module RestMyCase
  module Trial

    class Case

      attr_accessor :use_cases, :should_abort

      attr_reader :context,
                  :defendant,
                  :last_ancestor,
                  :context_class,
                  :defendant_class

      def initialize(last_ancestor, context_class, use_case_classes, attributes)
        @context         = build_context attributes, context_class
        @last_ancestor   = last_ancestor
        @defendant_class = build_defendant(last_ancestor, use_case_classes)
        @defendant       = @defendant_class.new @context
      end

      def aborted
        @should_abort || defendant.options[:should_abort]
      end

      protected ######################## PROTECTED #############################

      def build_context(attributes, context_class)
        return attributes if attributes.is_a?(context_class)

        context_class.new attributes
      end

      def build_defendant(last_ancestor, use_case_classes)
        Class.new(last_ancestor) { depends(*use_case_classes) }
      end

    end

  end
end
