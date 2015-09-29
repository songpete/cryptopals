
require_relative '../lib/crypto_functions.rb'


describe 'hex to b64 and back conversion' do
  hex_str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
  b64_str = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

  it 'should convert a hexstring to base64' do
    expect(convert_hex_to_b64(hex_str)).to eq(b64_str)
  end

  it 'should convert a base64 string to hex' do
    expect(convert_b64_to_hex(b64_str)).to eq(hex_str)
  end
end

describe 'string_to_hex' do
  it 'should convert an ascii string to hexstring' do
    expect(string_to_hex("daf")).to eq("646166")
  end
end
