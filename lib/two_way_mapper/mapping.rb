# frozen_string_literal: true

module TwoWayMapper
  class Mapping
    DIRECTIONS = [:left, :right].freeze

    attr_reader :rules, :left_class, :left_options, :right_class, :right_options

    def initialize
      @rules = []
    end

    [DIRECTIONS, DIRECTIONS.reverse].each do |from, to|
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{from}(plugin, options = {})
          @#{from}_class = node_class(plugin)
          @#{from}_options = options
        end

        def #{from}_selectors(mappable: false)
          rules.flat_map do |rule|
            if mappable && rule.from_#{from}_to_#{to}_only?
              []
            else
              rule.#{from}_nodes.map(&:selector)
            end
          end
        end

        def from_#{from}_to_#{to}(left_obj, right_obj)
          rules.each { |rule| rule.from_#{from}_to_#{to}(left_obj, right_obj) }
          #{to}_obj
        end
      CODE
    end

    def rule(left_selectors, right_selectors = {}, options = {})
      raise 'You need to set left before calling rule' unless left_class
      raise 'You need to set right before calling rule' unless right_class

      opt = options.dup
      left_opt = opt.delete(:left) || {}
      right_opt = opt.delete(:right) || {}

      if left_selectors.is_a?(Hash)
        raise ArgumentError if left_selectors.count < 2

        opt = left_selectors
        left_selectors = opt.keys.first
        left_opt.merge! opt.delete(left_selectors)
        right_selectors = opt.keys.first
        right_opt.merge!(opt.delete(right_selectors))
      end

      left_nodes = Array(left_selectors).map do |left_selector|
        left_class.new(left_selector, left_options.merge(left_opt))
      end
      right_nodes = Array(right_selectors).map do |right_selector|
        right_class.new(right_selector, right_options.merge(right_opt))
      end

      @rules << Rule.new(left_nodes, right_nodes, opt)
    end

    private

    def node_class(plugin)
      TwoWayMapper::Node.const_get(plugin.to_s.camelize)
    rescue NameError
      raise NameError, 'Cannot find node'
    end
  end
end
