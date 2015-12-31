module KeyboardReactor
  class Output
    def initialize(keyboard_json = nil, keyboard_hash: nil)
      @keyboard_hash = keyboard_hash || MultiJson.load(keyboard_json)
      @id = "#{(Time.now.to_f * 100).round}reactor"
    end

    attr_reader :tmp_dir, :keyboard_hash, :find_type, :id
    attr_writer :keyboard_type

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
      @hex_file_path ||= self.class.relative_path("#{firmware_path}/#{@id}.hex")
    end

    def keyboard_type
      @keyboard_type ||= @keyboard_hash['type']
      return @keyboard_type.to_s if self.class.known_types.include?(@keyboard_type)
      fail "Unknown keyboard type '#{@keyboard_type}', not one of #{self.class.known_types}"
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

    def hex
      return default_hex

      write_c_file
      # Override the default target with our ID so that we create unique files
      `cd #{firmware_path.to_s} && make clean && TARGET=#{id} make -e KEYMAP="#{id}"`
      read_hex_file
    end

    def existing_compilations
      Dir.chdir(firmware_path)
      Dir[*(%w(eep elf lss map sym hex).map { |ext| "*.#{ext}" })] - ['reference_compiled_default_firmware.hex']
    end

    def delete_existing_compilations
      existing_compilations.each { |f| File.delete(f) }
    end

    def default_hex
      @hex_file_path = "#{firmware_path}/#{keyboard_type}.hex"
      `cd #{firmware_path.to_s} && make clean && make KEYMAP="default"`
      read_hex_file
    end

    def read_hex_file
      File.read(hex_file_path)
    rescue
      fail "Unable to read generated hex file, #{hex_file_path}"
    end
  end
end
