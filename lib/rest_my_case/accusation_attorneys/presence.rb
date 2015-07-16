module RestMyCase
  module AccusationAttorneys

    # I DO NOT CLAIM OWNERSHIP OF THIS CODE, THIS CODE WAS TAKEN
    # FROM "ActiveModel" GEM AND ADAPTED TO RUN WITHOUT "ActiveSupport"
    # ORIGINAL SOURCE FILE: ActiveModel::Validations::PresenceValidator

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
