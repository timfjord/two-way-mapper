module TwoWayMapper
  module Node
    class Hash < Abstract
      def write(source, value)
        rewinded = rewind_forward source, 1

        rewinded[keys.last] = value if writable? rewinded[keys.last], value
      end

      private

      def rewind_to?(obj, key)
        obj.is_a?(::Hash) && obj.key?(key)
      end

      def create_node(obj, key)
        obj[key] = {}
      end

      def next_key(obj, key)
        obj[key]
      end
    end
  end
end
