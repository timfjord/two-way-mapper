module TwoWayMapper
  module Node
    class Object < Abstract
      def write(source, value)
        rewinded = rewind_forward source, 1

        rewinded.send "#{keys.last}=", value
      end

      private

      def rewind_to?(obj, key)
        obj.respond_to? key
      end

      def create_node(obj, key)
      end

      def next_key(obj, key)
        obj.send key
      end
    end
  end
end
