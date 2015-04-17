module RestMyCase
  module AccusationAttorneys

    class Presence < Each
      def validate_each(record, attr_name, value)
        record.errors.add(attr_name, :blank, options) if Helpers.blank?(value)
      end
    end

    module HelperMethods
      def validates_presence_of(*attr_names)
        validates_with Presence, _merge_attributes(attr_names)
      end
    end

  end
end
