# frozen_string_literal: true

module TwoWayMapper
  class Mapping
    DIRECTIONS = [:left, :right].freeze

    attr_reader :rules_list, :left_class, :left_options, :right_class, :right_options

    def initialize
      @rules_list = []
    end

    [DIRECTIONS, DIRECTIONS.reverse].each do |from, to|
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{from}(plugin, options = {})
          @#{from}_class = node_class(plugin)
          @#{from}_options = options
        end

        def #{from}_selectors(mappable: false)
          rules_list.flat_map do |rule|
            if mappable && rule.from_#{from}_to_#{to}_only?
              []
            else
              rule.#{from}_nodes.map(&:selector)
            end
          end
        end

        def from_#{from}_to_#{to}(left_obj, right_obj)
          rules_list.each { |rule| rule.from_#{from}_to_#{to}(left_obj, right_obj) }
          #{to}_obj
        end
      CODE
    end

    def rule(left_selectors, right_selectors = {}, options = {})
      raise 'left is not defined' unless left_class
      raise 'right is not defined' unless right_class

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

      @rules_list << Rule.new(
        build_nodes(left_selectors, left_class, left_options.merge(left_opt)),
        build_nodes(right_selectors, right_class, right_options.merge(right_opt)),
        opt
      )
    end

    def rules(hash)
      hash.each do |left_selector, right_selector|
        rule(left_selector, right_selector)
      end
    end

    private

    def node_class(plugin)
      TwoWayMapper::Node.const_get(plugin.to_s.camelize)
    rescue NameError
      raise NameError, 'Cannot find node'
    end

    def build_nodes(selectors, klass, opt)
      Array(selectors).map do |selector|
        klass.new(selector, opt)
      end
    end
  end
end
