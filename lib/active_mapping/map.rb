module ActiveMapping
  class Map
    delegate :[], to: :@maps

    def initialize
      @maps = {}
    end

    def register(name, options)
      left_plugin, right_plugin = Tools.first_item_from_hash! options
      raise ArgumentError unless left_plugin && right_plugin

      mapping = ActiveMapping::Mapping.new left_plugin, right_plugin
      yield mapping if block_given?
      @maps[name.to_sym] = mapping
    end
  end
end
