module ActiveMapping
  class Mapping
    attr_reader :rules

    def initialize(l_plugin, r_plugin)
      @left_plugin = l_plugin
      @right_plugin = r_plugin

      @rules = []
    end

    def left_class
      ActiveMapping::Node.const_get ActiveSupport::Inflector.camelize(@left_plugin.to_s)
    end

    def right_class
      ActiveMapping::Node.const_get ActiveSupport::Inflector.camelize(@right_plugin.to_s)
    end

    def rule(left_selector, right_selector = {}, opt = {})
      left_opt = opt.delete(:left_opt) || {}
      right_opt = opt.delete(:right_opt) || {}

      if left_selector.is_a?(Hash)
        raise ArgumentError if left_selector.count < 2
        opt = left_selector
        left_selector = opt.keys.first
        left_opt = opt.delete left_selector
        right_selector = opt.keys.first
        right_opt = opt.delete right_selector
      end

      left = left_class.new left_selector, left_opt
      right = right_class.new right_selector, right_opt

      @rules << Rule.new(left, right, opt)
    end

    [:from_left_to_right, :from_right_to_left].each do |method|
      class_eval <<-CODE, __FILE__, __LINE__ + 1
        def #{method}(left_obj, right_obj)
          rules.each { |r| r.#{method} left_obj, right_obj }
        end
      CODE
    end
  end
end
