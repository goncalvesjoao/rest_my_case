module RestMyCase
  module Config

    class General

      include Shared

      def initialize
        @dependencies_first         = true
        @parent_dependencies_first  = true
      end

      def get(attribute, use_case)
        custom_config = use_case.send(attribute)

        custom_config.nil? ? send(attribute) : custom_config
      end

    end

  end
end
