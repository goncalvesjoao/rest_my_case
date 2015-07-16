module RestMyCase
  module AccusationAttorneys

    # I DO NOT CLAIM OWNERSHIP OF THIS CODE, THIS CODE WAS TAKEN
    # FROM "ActiveModel" GEM AND ADAPTED TO RUN WITHOUT "ActiveSupport"
    # ORIGINAL SOURCE FILE: ActiveModel::Validations::NumericalityValidator

    class Numericality < Each
      CHECKS = { :greater_than => :>, :greater_than_or_equal_to => :>=,
                 :equal_to => :==, :less_than => :<, :less_than_or_equal_to => :<=,
                 :odd => :odd?, :even => :even? }.freeze

      RESERVED_OPTIONS = CHECKS.keys + [:only_integer]

      def check_validity!
        keys = CHECKS.keys - [:odd, :even]

        Helpers.slice(options, *keys).each do |option, value|
          next if value.nil? || value.is_a?(Numeric) || value.is_a?(Proc) || value.is_a?(Symbol)
          raise ArgumentError, ":#{option} must be a number, a symbol or a proc"
        end
      end

      def validate_each(record, attr_name, value)
        before_type_cast = "#{attr_name}_before_type_cast"

        raw_value = record.send(before_type_cast) if record.respond_to?(before_type_cast.to_sym)
        raw_value ||= value

        return if options[:allow_nil] && raw_value.nil?

        unless value = parse_raw_value_as_a_number(raw_value)
          record.errors.add(attr_name, :not_a_number, filtered_options(raw_value))
          return
        end

        if options[:only_integer]
          unless value = parse_raw_value_as_an_integer(raw_value)
            record.errors.add(attr_name, :not_an_integer, filtered_options(raw_value))
            return
          end
        end

        Helpers.slice(options, *CHECKS.keys).each do |option, option_value|
          next if option_value.nil?

          case option
          when :odd, :even
            unless value.to_i.send(CHECKS[option])
              record.errors.add(attr_name, option, filtered_options(value))
            end
          else
            option_value = option_value.call(record) if option_value.is_a?(Proc)
            option_value = record.send(option_value) if option_value.is_a?(Symbol)

            unless value.send(CHECKS[option], option_value)
              record.errors.add(attr_name, option, filtered_options(value).merge(:count => option_value))
            end
          end
        end
      end

      protected

      def parse_raw_value_as_a_number(raw_value)
        case raw_value
        when /\A0[xX]/
          nil
        else
          begin
            Kernel.Float(raw_value)
          rescue ArgumentError, TypeError
            nil
          end
        end
      end

      def parse_raw_value_as_an_integer(raw_value)
        raw_value.to_i if raw_value.to_s =~ /\A[+-]?\d+\Z/
      end

      def filtered_options(value)
        Helpers.except(options, *RESERVED_OPTIONS).merge!(:value => value)
      end
    end

    module HelperMethods
      def validates_numericality_of(*attr_names)
        validates_with Numericality, _merge_attributes(attr_names)
      end
    end

  end
end
