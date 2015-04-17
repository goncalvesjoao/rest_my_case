module RestMyCase
  module Config

    class General

      include Base

      def initialize
        @silence_dependencies_abort = false
      end

      def get(attribute, use_case_class)
        custom_config = use_case_class_config(attribute, use_case_class)

        custom_config.nil? ? send(attribute) : custom_config
      end

      protected ######################## PROTECTED #############################

      def use_case_class_config(attribute, use_case_class)
        return nil unless use_case_class.respond_to? attribute

        custom_config = use_case_class.send(attribute)

        if custom_config.nil?
          use_case_class_config(attribute, use_case_class.superclass)
        else
          custom_config
        end
      end

    end

  end
end
