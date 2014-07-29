module ActiveMapping
  module Tools
    class << self
      def first_item_from_hash!(hash)
        raise ArgumentError unless hash.is_a?(Hash)
        raise ArgumentError unless first = hash.first

        first
      end
    end
  end
end
