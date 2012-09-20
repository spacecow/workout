require 'spec_helper'

describe Colour do
  it "#hex_to_dec" do
    Colour.hex_to_dec('ff').should eq "255"
    Colour.hex_to_dec('8e').should eq "142"
    Colour.hex_to_dec('00').should eq "0"
  end

  it "rgb_array_hex" do
    Colour.rgb_array_hex("#ff0000").should eq ['ff','00','00']
    Colour.rgb_array_hex("#8e0071").should eq ['8e','00','71']
  end

  it "rgba_array_dec" do
    Colour.rgba_array_dec("#ff0000").should eq ['255','0','0','0.1']
    Colour.rgba_array_dec("#8e0071").should eq ['142','0','113','0.1']
  end
end
