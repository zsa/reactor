require 'multi_json'
require 'securerandom'
require 'liquid'

require 'keyboard_reactor/output'
module KeyboardReactor
  COLUMNS = {
    'ergodox_ez' => [7, 7, 6, 7, 5, 2, 1, 3, 7, 7, 6, 7, 5, 2, 1, 3],
    'planck' => [12, 12, 12, 11],
    'preonic' => [12, 12, 12, 12, 12]
  }

  BASE_DIR = File.dirname(__FILE__)
end
