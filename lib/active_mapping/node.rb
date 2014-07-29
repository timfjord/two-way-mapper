module ActiveMapping
  module Node
    extend ActiveSupport::Autoload

    autoload :Abstract, 'active_mapping/node/abstract'
    autoload :Hash,     'active_mapping/node/hash'
    autoload :Object,   'active_mapping/node/object'
  end
end
