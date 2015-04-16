module RestMyCase
  module Config

    class General

      include Base

      def initialize
        @silence_dependencies_abort = false
      end

      def get(attribute, use_case_class)
        custom_config = use_case_class.send(attribute)

        custom_config.nil? ? send(attribute) : custom_config
      end

    end

  end
end
