module KeyboardReactor
  class Output
    def initialize(keyboard_json = nil, tmp_dir: nil, keyboard_hash: nil)
      @tmp_dir = tmp_dir || self.class.relative_path('tmp')
      @keyboard_hash = keyboard_hash || MultiJson.load(keyboard_json)
      @id = (Time.now.to_f * 100).round
    end

    attr_reader :tmp_dir, :keyboard_hash, :find_type, :id

    def self.relative_path(path)
      File.expand_path(path, BASE_DIR)
    end

    def self.known_types
      COLUMNS.keys
    end

    def firmware_path
      self.class.relative_path("firmware/keyboard/#{keyboard_type}")
    end

    def c_file_path
      self.class.relative_path("#{firmware_path}/keymaps/keymap_#{@id}.c")
    end

    def hex_file_path
      self.class.relative_path("#{firmware_path}/keymap_#{@id}")
    end

    def write_output(keyboard_json)
    end

    def keyboard_type
      type = @keyboard_hash['type']
      return type.to_s if self.class.known_types.include?(type)
      fail "Unknown keyboard type '#{type}', not one of #{self.class.known_types}"
    end

    def layout_template
      path = "./keyboard_reactor/templates/#{keyboard_type}.liquid"
      File.read(self.class.relative_path(path))
    end

    def c_file
      Liquid::Template.parse(layout_template)
        .render(
          'columns' => COLUMNS[keyboard_type],
          'layout' => @keyboard_hash
        )
    end

    def write_c_file
      File.write(c_file_path, c_file)
    end

    def write_hex_file
      write_c_file
      `cd #{firmware_path.to_s} && make KEYMAP="#{id}"`
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
end
