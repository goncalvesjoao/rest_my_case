module RestMyCase

  module Helpers

    module_function

    def super_method(object, method_name, *args)
      return nil unless object.superclass.respond_to? method_name

      object.superclass.send method_name, *args
    end

    def blank?(object)
      if object.is_a?(String)
        object !~ /[^[:space:]]/
      else
        object.respond_to?(:empty?) ? object.empty? : !object
      end
    end

    def marked_for_destruction?(object)
      return false unless object.respond_to?(:marked_for_destruction?)

      object.marked_for_destruction?
    end

    def extract_options!(array)
      if array.last.is_a?(Hash) && array.last.instance_of?(Hash)
        array.pop
      else
        {}
      end
    end

    def symbolyze_keys(hash)
      hash.keys.each_with_object({}) do |key, symbolyzed_hash|
        symbolyzed_hash[key.to_sym] = hash[key]
      end
    end

    def except(hash, *keys)
      hash = hash.dup
      keys.each { |key| hash.delete(key) }
      hash
    end

    def slice(hash, *keys)
      keys.each_with_object({}) do |key, sliced_hash|
        sliced_hash[key] = hash[key]
      end
    end

    def call_proc_or_method(base, proc_or_method, object = nil)
      if proc_or_method.is_a?(Proc)
        base.instance_exec(object, &proc_or_method)
      else
        base.send(proc_or_method, object)
      end
    end

  end

end
