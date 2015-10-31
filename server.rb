require 'sinatra'
require 'securerandom'
require 'json'
require 'liquid'

configure { set :server, :puma }

COLUMNS = {
    'ergodox_ez' => [7,7,6,7,5,2,1,3,7,7,6,7,5,2,1,3],
    'planck' => [12,12,12,11],
    'preonic' => [12,12,12,12,12]
}

post '/' do
  layout = JSON.load(request.body.read)
  type = layout['type']

  uuid = SecureRandom.uuid()
  tpl = File.read("./templates/#{type}.liquid")

  c_file = Liquid::Template.parse(tpl).render({'columns' => COLUMNS[type], 'layout' => layout})

  # TODO: Commenting these out, for now - makes testing faster, but will wreak havoc
  # Also - cp is very slow
  # `cp -r qmk_firmware /tmp/#{uuid}`
  #output_file = "/tmp/#{uuid}/keyboard/#{type}/keymaps/keymap_#{uuid}.c"

  output_file = "qmk_firmware/keyboard/#{type}/keymaps/keymap_#{uuid}.c"

  f = File.new(output_file, 'w')
  f.write(c_file)
  f.close

  `cd qmk_firmware/keyboard/#{type} && make KEYMAP="#{uuid}"`

  status = 200

  begin
    hex = File.read("qmk_firmware/keyboard/#{type}/#{type}.hex")
  rescue Errno::ENOENT
    status = 400
  end

  headers = {
      'Content-Disposition' => "attachment;filename=#{type}.hex",
      'Content-Type' => 'application/octet-stream'
  }

  [status, headers, hex]
end
