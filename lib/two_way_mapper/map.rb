module TwoWayMapper
  class Map
    delegate :[], to: :@maps

    def initialize
      @maps = {}
    end

    def register(name)
      mapping = TwoWayMapper::Mapping.new
      yield mapping if block_given?
      @maps[name.to_sym] = mapping
    end
  end
end
