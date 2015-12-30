require 'spec_helper'

describe KeyboardReactor::Output do
  let(:ergodox_json) { File.read('spec/fixtures/ergodox_ez.json') }

  describe :initialize do
    context 'no passed path' do
      it 'assigns the default tmp dir' do
        keyboard_reactor = KeyboardReactor::Output.new(keyboard_hash: {})
        expect(keyboard_reactor.tmp_dir).to eq(keyboard_reactor.class.relative_path('tmp'))
      end
    end
    context 'passed keyboard_json' do
      it 'parses the json' do
        keyboard_reactor = KeyboardReactor::Output.new(ergodox_json)
        expect(keyboard_reactor.keyboard_hash['layers'][0]['keymap'].count).to eq 84
      end
    end
    context 'passed tmp_dir' do
      it 'assigns the passed tmp dir' do
        path = File.dirname(__FILE__)
        keyboard_reactor = KeyboardReactor::Output.new(tmp_dir: path, keyboard_hash: {})
        expect(keyboard_reactor.tmp_dir).to eq(path)
      end
    end
  end

  describe :write_output do
    it 'calls what it should call' do
      keyboard_reactor = KeyboardReactor::Output.new(ergodox_json)
      keyboard_reactor.write_hex_file
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

  describe 'c_file' do
    it 'returns the generated c file for ergodox_ez' do
      keyboard_reactor = KeyboardReactor::Output.new(ergodox_json)
      expect(keyboard_reactor.c_file).to_not be_nil
    end
  end
end
