module ActiveMapping
  module Node
    class Abstract
      DIVIDER = '.'

      attr_reader :selector

      def initialize(selector, opt = {})
        @selector = selector.to_s
        @opt = opt
      end

      def keys(&block)
        unless block
          block = @opt[:stringify_keys] ? :to_s : :to_sym
          block = block.to_proc
        end
        @selector.split(DIVIDER).map &block
      end

      def read(source)
        rewind_forward(source) { |obj, key| return nil }
      end

      def write(obj, value)
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
