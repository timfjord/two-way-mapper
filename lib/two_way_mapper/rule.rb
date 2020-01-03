# frozen_string_literal: true

module TwoWayMapper
  class Rule
    attr_reader :left_nodes, :right_nodes

    def initialize(left_nodes, right_nodes, opt = {})
      @left_nodes = left_nodes
      @right_nodes = right_nodes
      @options = opt
    end

    def from_left_to_right(left_obj, right_obj)
      return right_obj if from_right_to_left_only?

      value = read(left_nodes, [left_obj, right_obj], true)

      write(right_nodes, right_obj, value)
    end

    def from_right_to_left(left_obj, right_obj)
      return left_obj if from_left_to_right_only?

      value = read(right_nodes, [left_obj, right_obj], false)

      write(left_nodes, left_obj, value)
    end

    def from_right_to_left_only?
      @options[:from_right_to_left_only]
    end

    def from_left_to_right_only?
      @options[:from_left_to_right_only]
    end

    private

    def read(nodes, objects, left_to_right)
      callback = left_to_right ? :on_left_to_right : :on_right_to_left
      obj = left_to_right ? objects.first : objects.last
      value = nil

      nodes.each do |node|
        value = node.read(obj)
        value = map_value(value, left_to_right)
        if @options[callback].respond_to?(:call)
          args = [value] + objects + [node]
          value = @options[callback].call(*args)
        end

        break if value
      end

      value
    end

    def write(nodes, obj, value)
      nodes.each { |node| node.write(obj, value) }

      obj
    end

    def map_value(value, left_to_right)
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
