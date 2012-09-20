class Colour
  class << self
    def hex_to_dec(hex)
      hex.to_i(16).to_s(10)
    end

    def rgba_array_dec(hex)
      rgb_array_hex(hex).map{|e| hex_to_dec(e)}+['0.1']
    end
    def rgb_array_hex(hex)
      hex[1..-1].scan(/../)
    end
  end
end
