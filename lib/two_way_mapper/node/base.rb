# frozen_string_literal: true

module TwoWayMapper
  module Node
    class Base
      DIVIDER = '.'

      attr_accessor :selector, :options

      def initialize(selector, options = {})
        @selector, @options = selector, options
      end

      def keys(&block)
        unless block
          block = options[:stringify_keys] ? :to_s : :to_sym
          block = block.to_proc
        end
        selector.split(DIVIDER).map(&block)
      end

      def read(source)
        rewind_forward(source) { |_obj, _key| return nil }
      end

      def write(_obj, _value)
        raise NotImplementedError
      end

      def writable?(current_value, new_value)
        !options[:write_if] ||
          !options[:write_if].respond_to?(:call) ||
          options[:write_if].call(current_value, new_value)
      end

      private

      def rewind_forward(obj, margin = 0)
        to = -(1 + margin.to_i.abs)

        keys[0..to].each do |key|
          unless rewind_to?(obj, key)
            block_given? ? yield(obj, key) : create_node(obj, key)
          end
          obj = next_key(obj, key)
        end

        obj
      end

      def rewind_to?(_obj, _key)
        raise NotImplementedError
      end

      def create_node(_obj, _key)
        raise NotImplementedError
      end

      def next_key(_obj, _key)
        raise NotImplementedError
      end
    end
  end
end
