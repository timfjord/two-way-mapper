# frozen_string_literal: true

module TwoWayMapper
  class Rule
    attr_reader :left, :right

    def initialize(left, right, opt = {})
      @left = left
      @right = right
      @options = opt
    end

    def from_left_to_right(left_obj, right_obj)
      return right_obj if from_right_to_left_only?

      value = left.read(left_obj)
      value = map_value(value, true)
      if @options[:on_left_to_right].respond_to?(:call)
        value = @options[:on_left_to_right].call(value, left_obj, right_obj)
      end
      right.write(right_obj, value)

      right_obj
    end

    def from_right_to_left(left_obj, right_obj)
      return left_obj if from_left_to_right_only?

      value = right.read(right_obj)
      value = map_value(value, false)
      if @options[:on_right_to_left].respond_to?(:call)
        value = @options[:on_right_to_left].call(value, left_obj, right_obj)
      end
      left.write(left_obj, value)

      left_obj
    end

    def from_right_to_left_only?
      @options[:from_right_to_left_only]
    end

    def from_left_to_right_only?
      @options[:from_left_to_right_only]
    end

    private

    def map_value(value, left_to_right = true)
      map = @options[:map]
      if map.is_a?(Hash)
        map = map.invert unless left_to_right
        default_key = "default_#{left_to_right ? 'left' : 'right'}".to_sym
        map[value] || @options[default_key] || @options[:default]
      else
        value
      end
    end
  end
end
