require 'rails'

module ActiveMapping
  class Railtie < Rails::Railtie
    initializer "active_mapping.set_load_path" do |app|
      path = Rails.root.join('app', 'mappings', '*.rb').to_s
      Dir[path].each{ |file| load file }
    end
  end
end
