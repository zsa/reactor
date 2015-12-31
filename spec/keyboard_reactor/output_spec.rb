require 'spec_helper'

describe KeyboardReactor::Output do
  let(:ergodox_json) do
    File.read(File.expand_path('../fixtures/ergodox_ez.json', File.dirname(__FILE__)))
  end

  describe :initialize do
    context 'passed keyboard_json' do
      it 'parses the json' do
        keyboard_reactor = KeyboardReactor::Output.new(ergodox_json)
        expect(keyboard_reactor.keyboard_hash['layers'][0]['keymap'].count).to eq 84
      end
    end
  end

  describe 'find_type' do
    it "raises an error if the type isn't known" do
      expect { KeyboardReactor::Output.new(keyboard_hash: { 'type' => 'cool keyboard' }).keyboard_type }.to raise_error
    end
    it 'returns the type' do
      expect(KeyboardReactor::Output.new(keyboard_hash: { 'type' => 'ergodox_ez' }).keyboard_type).to eq('ergodox_ez')
    end
  end

  describe 'layout_template' do
    %w(ergodox_ez planck preonic).each do |layout_type|
      it "finds the layout file for #{layout_type}" do
        keyboard_reactor = KeyboardReactor::Output.new(keyboard_hash: { 'type' => layout_type })
        expect(keyboard_reactor.layout_template).to_not be_nil
      end
    end
  end

  describe 'read hex file' do
    it "fails if a file isn't present" do
      keyboard_reactor = KeyboardReactor::Output.new(keyboard_hash: { 'type' => 'ergodox_ez' })
      keyboard_reactor.delete_existing_compilations
      expect { keyboard_reactor.read_hex_file }.to raise_error
    end
  end

  describe 'c_file' do
    it 'returns the generated c file for ergodox_ez' do
      keyboard_reactor = KeyboardReactor::Output.new(ergodox_json)
      expect(keyboard_reactor.c_file).to_not be_nil
    end
  end

  describe 'write_c_file' do
    it 'writes a c file' do
      keyboard_reactor = KeyboardReactor::Output.new(keyboard_hash: { 'type' => 'ergodox_ez' })
      c_file = keyboard_reactor.c_file_path
      expect(File.exist?(c_file)).to be_false
      keyboard_reactor.write_c_file
      expect(File.exist?(c_file)).to be_true
    end
  end

  describe 'write default ergodox hex' do
    # Because difficulties writing the layout file correctly,
    # we're ensuring that we can correctly compile a hex file as a test
    it 'writes the default hex file' do
      keyboard_reactor = KeyboardReactor::Output.new(keyboard_hash: {})
      keyboard_reactor.keyboard_type = 'ergodox_ez'
      firmware_dir = keyboard_reactor.firmware_path
      hex_file = "#{firmware_dir}/ergodox_ez.hex"
      keyboard_reactor.delete_existing_compilations
      keyboard_reactor.default_hex
      expect(File.exist?(hex_file)).to be_true
    end
  end

  describe :hex do
    it 'returns default hex, because things are broken' do
      keyboard_reactor = KeyboardReactor::Output.new(ergodox_json)
      expect(keyboard_reactor).to receive(:default_hex) { 'foo' }
      expect(keyboard_reactor.hex).to eq('foo')
    end
  end
end
