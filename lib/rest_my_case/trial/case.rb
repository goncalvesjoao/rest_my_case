module RestMyCase
  module Trial

    class Case

      attr_accessor :use_cases

      attr_reader :context, :defendant

      def initialize(use_case_classes, attributes = {})
        attributes ||= {}

        unless attributes.respond_to?(:to_hash)
          raise ArgumentError.new('Must respond_to method #to_hash')
        end

        @context    = Context::Base.new attributes.to_hash
        @defendant  = Defendant.new use_case_classes
        @use_cases  = []
      end

    end

  end
end
