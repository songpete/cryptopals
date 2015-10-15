require_relative '../lib/encryption.rb'

# Byte-at-a-time ECB decryption (Simple)
#
# Find the block size
#
# Detect if it's encrypted using ECB (even though we already know it is)
#
# Make a dictionary of every possible last byte of string starting with "AAAAA...."


b64 = "Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK"
PLAINTEXT = Base64.decode64(b64)     # don't look!
STATIC_KEY = SecureRandom.random_bytes(16)


def static_key_ecb(message, input_string)
  appended_text = input_string + message
  cipher = encrypt_ecb(appended_text, STATIC_KEY)
end

# Input a string that repeats over 32 characters to allow ECB detection
test_input = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"
cipher = static_key_ecb(PLAINTEXT, test_input)

# Detect the cipher is encrypted using ECB (even though we already know it is)
puts "ECB encrypted? #{ecb_encrypted?(cipher)}"

# Find the block size: feed repeating bytes until a duplicate block returns.
test_input = ''
block_size = 0

1.upto(200) do |n|  # try up to a block of size 100
  test_input << "A"
  block_size = (n / 2) if ecb_encrypted?(static_key_ecb(PLAINTEXT, test_input))
  break if block_size > 0
end

puts "Block size is #{block_size}."

# Get the original text

def find_last_byte(target, snip, round)
  matched_letter = ''

# 32.upto(126) do |n|    # newlines is 10
  10.upto(126) do |n|
    full_block = snip + n.chr
    firstblock = static_key_ecb(PLAINTEXT, full_block).scan(/.{16}/m)[round]
    if target == firstblock
      matched_letter = n.chr
      break
    end
  end
  return matched_letter
end

aaa = "AAAAAAAAAAAAAAA"   # len 15
pad1 = "AAAAAAAAAAAAAAA"
teststring = "AAAAAAAAAAAAAAA"
found_text = ''
counter = 0

1.upto(138) do |n|
  targ = static_key_ecb(PLAINTEXT, pad1).scan(/.{16}/m)[counter]
  found_text << last_char = find_last_byte(targ, teststring, counter)
  if pad1 == ''
    counter += 1
    pad1 = "AAAAAAAAAAAAAAA"
    teststring = "AAAAAAAAAAAAAAA" + found_text
  else
    pad1[0] = ''
    teststring[0] = ''
    teststring += last_char
  end
end

puts "Found text: #{found_text}"

