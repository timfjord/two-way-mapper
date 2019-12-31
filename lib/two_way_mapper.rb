# frozen_string_literal: true

require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'
require 'active_support/inflector'

module TwoWayMapper
  extend ActiveSupport::Autoload

  autoload :Map
  autoload :Mapping
  autoload :Rule
  autoload :Node
  autoload :Tools

  class << self
    def map
      @map ||= Map.new
    end

    delegate :register, to: :map
    delegate :[],       to: :map
  end
end

require 'two_way_mapper/railtie' if defined? Rails
