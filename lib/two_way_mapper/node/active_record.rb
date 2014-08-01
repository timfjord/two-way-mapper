module TwoWayMapper
  module Node
    class ActiveRecord < Object
      def rewind_to?(obj, key)
        super && obj.send(key)
      end

      def create_node(obj, key)
        obj.send "build_#{key}"
      end
    end
  end
end
