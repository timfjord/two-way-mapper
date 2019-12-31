# frozen_string_literal: true

require 'rails'

module TwoWayMapper
  class Railtie < Rails::Railtie
    initializer 'two_way_mapper.set_load_path' do |app|
      path = Rails.root.join('app', 'mappings', '*.rb').to_s
      Dir[path].each { |file| load file }
    end
  end
end
