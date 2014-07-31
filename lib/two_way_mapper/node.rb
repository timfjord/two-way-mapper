module TwoWayMapper
  module Node
    extend ActiveSupport::Autoload

    autoload :Abstract, 'two_way_mapper/node/abstract'
    autoload :Hash,     'two_way_mapper/node/hash'
    autoload :Object,   'two_way_mapper/node/object'
  end
end
