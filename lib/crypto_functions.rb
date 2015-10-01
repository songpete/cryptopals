require 'base64'
require_relative 'scoring.rb'

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

# key of any length that is xor'd with a message of any length
def repeat_key_xor(message, key)
  message_key_ratio = (message.length / key.length) + 1
  key_bytes = (key * message_key_ratio).bytes
  output = message.bytes.map { |mb| mb ^ key_bytes.shift }

  return bytes_to_string(output)
end

# Hamming distance is the number of differing bits. XOR results in a 1 when the bits differ.
# Thus, we can XOR two bytes and add up the ones in the result to get the hamming distance.
def byte_hamming_distance(byte1, byte2)
  (byte1 ^ byte2).to_s(2).count("1")
end

def string_hamming_distance(string1, string2)
  raise "Strings must be of equal length to get hamming distance" if string1.length != string2.length

  distance = 0
  combined = string1.bytes.zip(string2.bytes).flatten
  combined.each_slice(2) { |a,b| distance += byte_hamming_distance(a,b) }

  return distance
end

# Guess the keysize based on hamming distance. Tries 2 to 40. This can probably be improved.
def guess_keysize(str, blocks=5, maxkeysize=40)
  raise "Blocks * maxkeysize * 2 can't be greater than the string length" unless (str.length + 1) > (blocks * maxkeysize * 2)

  sbytes = str.bytes
  all_distances = {}
  blocks *= 2    # this is the # of block pairs to try

  2.upto(maxkeysize) do |a|
    slices = []; counter = 0; total_ham = 0

    sbytes.each_slice(a) do |sl|
      slices << sl
      break if counter > blocks
      counter += 1
    end

    slices.each_slice(2) do |first, second|
      first.each_with_index do |byte, i|
        total_ham += byte_hamming_distance(byte, second[i])
      end
    end

    all_distances[a] = (total_ham / blocks.to_f) / a.to_f
  end

  all_distances.sort_by {|k,v| v}
end

# An array: ["a","b","c","d","e","f","g","h","i","j","k","l"] input with length 3 would return:
# => [["a","d","g","j"], ["b","e","h","k"], ["c","f","i","l"]]
def nest_into_columns(ary, len)
  col_ary = []
  1.upto(len) { col_ary << [] }
  ary.each_slice(len) do |slice|
    0.upto(len) { |c| col_ary[c] << slice[c] if slice[c] != nil }
  end
  return col_ary
end

# Find a repeating key, when length of key is known. Number of columns is the key length and
# represent characters which should be under the same key letter.
def find_key(str, len)
  byte_ary = str.bytes
  skey = ''

  column_ary = nest_into_columns(byte_ary, len)

  column_ary.each do |column|
    lowest_score = 222
    best_key = ''

    # english ascii codes http://www.ascii.cl/htmlcodes.htm
    # special chars and foreign can go beyond 126
    32.upto(126) do |key|
      snip = ''
      column.each { |c| snip += (c ^ key).chr }
      score = score_text_two(snip)

      if score < lowest_score
        lowest_score = score
        best_key = key.chr
      end
    end

    skey += best_key
  end

  skey
end

def pkcs7_pad(str, block_size)
  remainder = str.length % block_size
  return str if remainder == 0

  add_bytes = block_size - remainder                 # number of bytes needed to add
  pad_char = add_bytes.chr
  result = str.dup
  add_bytes.times { result << pad_char }

  return result
end
