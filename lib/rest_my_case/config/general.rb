module RestMyCase
  module Config

    class General

      include Base

      def initialize
        @silence_dependencies_abort = false
      end

      def get(attribute, use_case)
        custom_config = use_case.send(attribute)

        custom_config.nil? ? send(attribute) : custom_config
      end

    end

  end
end
