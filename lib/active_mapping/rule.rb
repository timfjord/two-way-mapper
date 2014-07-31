module ActiveMapping
  class Rule
    attr_reader :left, :right

    def initialize(left, right, opt = {})
      @left = left
      @right = right
      @options = opt
    end

    { left: :right, right: :left }.each do |from, to|
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def from_#{from}_to_#{to}(left_obj, right_obj)
          value = #{from}.read #{from}_obj
          value = map_value value, #{(from == :left).inspect}
          #{to}.write #{to}_obj, value
        end
      CODE
    end

    private

    def map_value(value, left_to_right = true)
      map = @options[:map]
      if map && map.is_a?(Hash)
        map = map.invert unless left_to_right
        value = map[value] || @options[:default]
      else
        value
      end
    end
  end
end
