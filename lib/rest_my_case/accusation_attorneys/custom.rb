module RestMyCase
  module AccusationAttorneys

    class Custom < Base

      attr_reader :methods

      def initialize(args)
        @methods = args

        super Helpers.extract_options!(args)
      end

      def validate(record)
        [*methods].map { |method| base.send(method, record) }.all?
      end

    end

  end
end
