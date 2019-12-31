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
          rules.each_with_object [] do |rule, memo|
            next if mappable && rule.from_#{from}_to_#{to}_only?

            memo << rule.#{from}.selector
          end
        end

        def from_#{from}_to_#{to}(left_obj, right_obj)
          rules.each { |rule| rule.from_#{from}_to_#{to}(left_obj, right_obj) }
          #{to}_obj
        end
      CODE
    end

    def rule(left_selector, right_selector = {}, options = {})
      raise 'You need to set left before calling rule' unless left_class
      raise 'You need to set right before calling rule' unless right_class

      opt = options.dup
      left_opt = opt.delete(:left) || {}
      right_opt = opt.delete(:right) || {}

      if left_selector.is_a?(Hash)
        raise ArgumentError if left_selector.count < 2

        opt = left_selector
        left_selector = opt.keys.first
        left_opt.merge! opt.delete(left_selector)
        right_selector = opt.keys.first
        right_opt.merge!(opt.delete(right_selector))
      end

      left = left_class.new(left_selector, left_options.merge(left_opt))
      right = right_class.new(right_selector, right_options.merge(right_opt))

      @rules << Rule.new(left, right, opt)
    end

    private

    def node_class(plugin)
      TwoWayMapper::Node.const_get(plugin.to_s.camelize)
    rescue NameError
      raise NameError, 'Cannot find node'
    end
  end
end
