# frozen_string_literal: true

module TwoWayMapper
  module Tools
    class << self
      def first_item_from_hash!(hash)
        raise ArgumentError unless hash.is_a?(Hash)
        raise ArgumentError unless (first = hash.first)

        hash.delete(first[0])
        first
      end
    end
  end
end
