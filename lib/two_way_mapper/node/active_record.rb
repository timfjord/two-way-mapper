module TwoWayMapper
  module Node
    class ActiveRecord < Object
      def create_node(obj, key)
        obj.send "build_#{key}"
      end
    end
  end
end
