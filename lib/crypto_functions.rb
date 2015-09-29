
def assert_equal(first, second); puts (first == second) ? "Pass" : "Fail"; end

# convert hex to base 64
def convert_hex_to_b64(str); [[str].pack("H*")].pack("m0"); end

# convert base 64 to hex
def convert_b64_to_hex(str); str.unpack("m0").first.unpack("H*").first; end

# take two hex strings, xor them and then re encode as hex string
def xor_hex_strings(hex1, hex2)
  (hex1.to_i(16) ^ hex2.to_i(16)).to_s(16)   # (hex1.hex ^ hex2.hex).to_s(16)  # also works
end

def bytes_to_hex(bytes)
  output = []
  bytes.each { |b| output << b.to_s(16).rjust(2, "0") }
  return output.join('')
end

def hex_to_text(hx)
  bts = hex_to_bytes(hx)
  bytes_to_string(bts)
end

def hex_to_bytes(hex)
  output = []
  hex.scan(/../).each { |h| output << h.hex }
  return output
end
def hexstring_to_bytes(hex); [hex].pack('H*').bytes; end # returns an array of bytes, same as above?

def bytes_to_string(bytes); bytes.pack('c*'); end
def string_to_hex(str); bytes_to_hex(str.bytes); end

