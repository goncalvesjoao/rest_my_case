module RestMyCase
  module AccusationAttorneys

    class Length < Each
      MESSAGES  = { is: :wrong_length, minimum: :too_short, maximum: :too_long }.freeze
      CHECKS    = { is: :==, minimum: :>=, maximum: :<= }.freeze

      RESERVED_OPTIONS  = [:minimum, :maximum, :within, :is, :tokenizer, :too_short, :too_long]

      def initialize(options)
        if range = (options.delete(:in) || options.delete(:within))
          raise ArgumentError, ":in and :within must be a Range" unless range.is_a?(Range)
          options[:minimum], options[:maximum] = range.min, range.max
        end

        if options[:allow_blank] == false && options[:minimum].nil? && options[:is].nil?
          options[:minimum] = 1
        end

        super
      end

      def check_validity!
        keys = CHECKS.keys & options.keys

        if keys.empty?
          raise ArgumentError, 'Range unspecified. Specify the :in, :within, :maximum, :minimum, or :is option.'
        end

        keys.each do |key|
          value = options[key]

          unless (value.is_a?(Integer) && value >= 0) || value == Float::INFINITY
            raise ArgumentError, ":#{key} must be a nonnegative Integer or Infinity"
          end
        end
      end

      def validate_each(record, attribute, value)
        value = tokenize(value)
        value_length = value.respond_to?(:length) ? value.length : value.to_s.length
        errors_options = Helpers.except(options, *RESERVED_OPTIONS)

        CHECKS.each do |key, validity_check|
          next unless check_value = options[key]

          if !value.nil? || skip_nil_check?(key)
            next if value_length.send(validity_check, check_value)
          end

          errors_options[:count] = check_value

          default_message = options[MESSAGES[key]]
          errors_options[:message] ||= default_message if default_message

          record.errors.add(attribute, MESSAGES[key], errors_options)
        end
      end

      private

      def tokenize(value)
        if options[:tokenizer] && value.kind_of?(String)
          options[:tokenizer].call(value)
        end || value
      end

      def skip_nil_check?(key)
        key == :maximum && options[:allow_nil].nil? && options[:allow_blank].nil?
      end
    end

    module HelperMethods
      def validates_length_of(*attr_names)
        validates_with Length, _merge_attributes(attr_names)
      end

      alias_method :validates_size_of, :validates_length_of
    end

  end
end
