require 'ostruct'

module RestMyCase

  class Context < OpenStruct

    attr_reader :errors

    def initialize(attributes)
      if !attributes.is_a?(::Hash) && !attributes.is_a?(Context)
        raise ArgumentError.new('Must be a Hash or Context')
      end

      super Helpers.stringify_keys(attributes)

      @errors = Hash.new { |hash, key| hash[key] = [] }
    end

    def valid?
      @errors.empty?
    end

    alias :ok? :valid?

    def serializable_hash(options = nil)
      marshal_dump
    end

    alias :to_hash :serializable_hash

  end

end
