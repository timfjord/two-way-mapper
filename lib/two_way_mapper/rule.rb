# frozen_string_literal: true

module TwoWayMapper
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
          value = #{from}.read(#{from}_obj)
          value = map_value(value, #{(from == :left).inspect})
          if @options[:on_#{from}_to_#{to}].respond_to?(:call)
            value = @options[:on_#{from}_to_#{to}].call(value)
          end
          #{to}.write(#{to}_obj, value)

          #{to}_obj
        end
      CODE
    end

    private

    def map_value(value, left_to_right = true)
      map = @options[:map]
      if map && map.is_a?(Hash)
        map = map.invert unless left_to_right
        default_key = "default_#{left_to_right ? 'left' : 'right'}".to_sym
        value = map[value] || @options[default_key] || @options[:default]
      else
        value
      end
    end
  end
end
