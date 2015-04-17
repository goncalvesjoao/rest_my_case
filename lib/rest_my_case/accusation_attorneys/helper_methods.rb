module RestMyCase
  module AccusationAttorneys

    module HelperMethods

      def _merge_attributes(attr_names)
        options = Helpers.symbolyze_keys(Helpers.extract_options!(attr_names))
        attr_names.flatten!
        options[:attributes] = attr_names
        options
      end

    end

  end
end
