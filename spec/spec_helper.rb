lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'two-way-mapper'

require 'rspec/its'
require 'ostruct'
require 'debugger' if defined? Debugger

RSpec.configure do |config|
end
