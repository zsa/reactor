require 'spec_helper'

describe KeyboardReactor do
  describe :write_output do
    it 'calls what it should call'
  end

  describe 'find_type' do
    it "raises an error if the type isn't known" do
      expect{KeyboardReactor.find_type('type' => 'cool keyboard')}.to raise_error
    end
    it 'returns the type' do
      expect(KeyboardReactor.find_type('type' => 'ergodox_ez')).to eq('ergodox_ez')
    end
  end

  describe 'layout_file' do
    ['ergodox_ez', 'planck', 'preonic'].each do |layout_type|
      it "finds the layout file for #{layout_type}" do
        expect(KeyboardReactor.layout_file(layout_type)).to_not be_nil
      end
    end
  end
end
