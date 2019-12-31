# frozen_string_literal: true

module TwoWayMapper
  module Node
    class Object < Base
      def write(source, value)
        rewinded = rewind_forward(source, 1)

        return unless writable?(rewinded.send(keys.last), value)

        rewinded.send("#{keys.last}=", value)
      end

      private

      def rewind_to?(obj, key)
        obj.respond_to?(key)
      end

      def create_node(obj, key)
      end

      def next_key(obj, key)
        obj.send(key)
      end
    end
  end
end
