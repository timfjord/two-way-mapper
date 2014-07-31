module TwoWayMapper
  module Node
    class Abstract
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
        selector.split(DIVIDER).map &block
      end

      def read(source)
        rewind_forward(source) { |obj, key| return nil }
      end

      def write(obj, value)
      end

      def writable?(data)
        !options[:write_if] ||
        !options[:write_if].respond_to?(:call) ||
        options[:write_if].call(data)
      end

      private

      def rewind_forward(obj, margin = 0)
        to = -(1 + margin.to_i.abs)
        keys[0..to].each do |key|
          unless rewind_to?(obj, key)
            if block_given?
              yield obj, key
            else
              create_node obj, key
            end
          end
          obj = next_key obj, key
        end

        obj
      end

      def rewind_to?(obj, key)
      end

      def create_node(obj, key)
      end

      def next_key(obj, key)
      end
    end
  end
end
