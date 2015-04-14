module RestMyCase
  module TrialCase

    class Base

      attr_reader   :defendant, :context

      attr_accessor :use_cases

      def initialize(defendant, attributes = {})
        attributes ||= {}

        unless attributes.respond_to?(:to_hash)
          raise ArgumentError.new('Must respond_to method #to_hash')
        end

        @context   = Context.new attributes.to_hash
        @defendant = defendant
        @use_cases = []
      end

    end

  end
end
