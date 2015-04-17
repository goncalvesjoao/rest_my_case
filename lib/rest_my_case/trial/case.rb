module RestMyCase
  module Trial

    class Case

      attr_accessor :use_cases, :should_abort

      attr_reader :context, :defendant, :last_ancestor, :use_case_classes

      def initialize(last_ancestor, use_case_classes, attributes)
        @context          = build_context attributes
        @defendant        = build_defendant(last_ancestor, use_case_classes)
        @last_ancestor    = last_ancestor
        @use_case_classes = use_case_classes
      end

      def aborted
        @should_abort || defendant.options[:should_abort]
      end

      protected ######################## PROTECTED #############################

      def build_context(attributes)
        return attributes if attributes.is_a?(Context::Base)

        Context::Base.new attributes
      end

      def build_defendant(defendant_class, use_case_classes)
        Class.new(defendant_class) do
          depends(*use_case_classes)
        end.new(@context)
      end

    end

  end
end
