module RestMyCase
  module AccusationAttorneys

    # I DO NOT CLAIM OWNERSHIP OF THIS CODE, THIS CODE WAS TAKEN
    # FROM "ActiveModel" GEM AND ADAPTED TO RUN WITHOUT "ActiveSupport"
    # ORIGINAL SOURCE FILE: ActiveModel::Validations::FormatValidator

    class Format < Each
      def validate_each(record, attribute, value)
        if options[:with]
          regexp = option_call(record, :with)
          record_error(record, attribute, :with, value) if value.to_s !~ regexp
        elsif options[:without]
          regexp = option_call(record, :without)
          record_error(record, attribute, :without, value) if value.to_s =~ regexp
        end
      end

      def check_validity!
        unless options.include?(:with) ^ options.include?(:without)  # ^ == xor, or "exclusive or"
          raise ArgumentError, "Either :with or :without must be supplied (but not both)"
        end

        check_options_validity(options, :with)
        check_options_validity(options, :without)
      end

      private

      def option_call(record, name)
        option = options[name]
        option.respond_to?(:call) ? option.call(record) : option
      end

      def record_error(record, attribute, name, value)
        record.errors.add(attribute, :invalid, Helpers.except(options, name).merge!(value: value))
      end

      def regexp_using_multiline_anchors?(regexp)
        regexp.source.start_with?("^") ||
          (regexp.source.end_with?("$") && !regexp.source.end_with?("\\$"))
      end

      def check_options_validity(options, name)
        option = options[name]
        if option && !option.is_a?(Regexp) && !option.respond_to?(:call)
          raise ArgumentError, "A regular expression or a proc or lambda must be supplied as :#{name}"
        elsif option && option.is_a?(Regexp) &&
              regexp_using_multiline_anchors?(option) && options[:multiline] != true
          raise ArgumentError, "The provided regular expression is using multiline anchors (^ or $), " \
          "which may present a security risk. Did you mean to use \\A and \\z, or forgot to add the " \
          ":multiline => true option?"
        end
      end
    end

    module HelperMethods
      def validates_format_of(*attr_names)
        validates_with Format, _merge_attributes(attr_names)
      end
    end

  end
end
