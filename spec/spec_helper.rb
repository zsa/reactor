require 'rspec'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'keyboard_reactor'
require 'pp'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

def store_terms_fixture
  items = []
  # file = File.read('spec/fixtures/multiple_categories.json')
  # file.each_line { |l| items << MultiJson.load(l) }
  # loader = Soulheart::Loader.new
  # loader.clear(true)
  # loader.load(items)
end
