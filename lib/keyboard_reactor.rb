require 'multi_json'
require 'securerandom'
require 'liquid'

module KeyboardReactor
  COLUMNS = {
    'ergodox_ez' => [7,7,6,7,5,2,1,3,7,7,6,7,5,2,1,3],
    'planck' => [12,12,12,11],
    'preonic' => [12,12,12,12,12]
  }

  BASE_DIR = File.dirname(__FILE__)

  def self.relative_path(path)
    File.expand_path(path, BASE_DIR)
  end

  def self.known_types
    COLUMNS.keys
  end

  def self.write_output(keyboard_json)
    keyboard_hash = MultiJson.load(keyboard_json)
    pp keyboard_hash
    type = type_from_hash(keyboard_hash)
    layout_file(type)
  end

  def self.find_type(keyboard_hash)
    t = keyboard_hash['type']
    return t.to_s if known_types.include?(t)
    fail "Unknown keyboard type '#{type}', not one of #{known_types}"
  end

  def self.layout_file(type)
    File.read(relative_path("./keyboard_reactor/templates/#{type}.liquid"))
  end

  # post '/' do
  #   layout = JSON.load(request.body.read)
  #   type = layout['type']

  #   uuid = SecureRandom.uuid()
  #   tpl = File.read("./templates/#{type}.liquid")

  #   c_file = Liquid::Template.parse(tpl).render({'columns' => COLUMNS[type], 'layout' => layout})

  #   # TODO: Commenting these out, for now - makes testing faster, but will wreak havoc
  #   # Also - cp is very slow
  #   # `cp -r qmk_firmware /tmp/#{uuid}`
  #   #output_file = "/tmp/#{uuid}/keyboard/#{type}/keymaps/keymap_#{uuid}.c"

  #   output_file = "qmk_firmware/keyboard/#{type}/keymaps/keymap_#{uuid}.c"

  #   f = File.new(output_file, 'w')
  #   f.write(c_file)
  #   f.close

  #   `cd qmk_firmware/keyboard/#{type} && make KEYMAP="#{uuid}"`

  #   status = 200

  #   begin
  #     hex = File.read("qmk_firmware/keyboard/#{type}/#{type}.hex")
  #   rescue Errno::ENOENT
  #     status = 400
  #   end

  #   headers = {
  #       'Content-Disposition' => "attachment;filename=#{type}.hex",
  #       'Content-Type' => 'application/octet-stream'
  #   }

  #   [status, headers, hex]
  # end
end