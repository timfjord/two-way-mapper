require 'active_support/dependencies/autoload'
require 'active_support/core_ext/module/delegation'

module ActiveMapping
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

require 'active_mapping/railtie' if defined? Rails
