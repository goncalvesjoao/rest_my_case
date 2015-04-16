module RestMyCase
  module Trial

    class Case

      attr_accessor :use_cases, :aborted

      attr_reader :context, :defendant

      def initialize(use_case_classes, attributes)
        @aborted   = false
        @context   = build_context(attributes)
        @defendant = Defendant.new use_case_classes
        @use_cases = []
      end

      protected ######################## PROTECTED #############################

      def build_context(attributes)
        return attributes if attributes.is_a?(Context::Base)

        Context::Base.new attributes
      end

    end

  end
end
