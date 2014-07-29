lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'activemapping'

require 'rspec/its'
require 'ostruct'
require 'debugger'

RSpec.configure do |config|
end
