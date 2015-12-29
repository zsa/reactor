require 'rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'keyboard_reactor'
require 'pp'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
