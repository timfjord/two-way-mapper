module ActiveMapping
  class Rule
    attr_reader :left, :right

    def initialize(left, right, opt = {})
      @left = left
      @right = right
      @opt = opt
    end

    def from_left_to_right(left_obj, right_obj)
      value = left.read left_obj
      value = map_value value
      right.write right_obj, value
    end

    def from_right_to_left(left_obj, right_obj)
      value = right.read right_obj
      value = map_value value, false
      left.write left_obj, value
    end

    private

    def map_value(value, left_to_right = true)
      map = @opt[:map]
      if map && map.is_a?(Hash)
        map = map.invert unless left_to_right
        value = map[value] || @opt[:default]
      else
        value
      end
    end
  end
end
