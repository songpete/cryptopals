
# Byte-at-a-time ECB decryption

require_relative '../lib/encryption.rb'
STATIC_KEY = 'i198dnnapqie2mnj'

# from challenge 12: produce AES-128-ECB(your-string || unknow-string, random-key)
def static_key_ecb(message)
  unknown = "Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkgaGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBqdXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUgYnkK"
  udecoded = Base64.decode64(unknown)

  message_appended = message + udecoded
  message_appended = pkcs7_pad(message_appended, 16)

  cipher = encrypt_ecb(message_appended, STATIC_KEY)
end

def detect_prefix_size(cipher, len)
  return false if !cipher || cipher.length < 3*len
  blocks = cipher.scan(/.{#{len}}/m)

  return blocks[1] == blocks[2]
end

# AES-128(random-prefix || attacker-controlled || target-bytes, random-key)
def random_prefix_ecb(message)
  random_length = 10 + rand(10)
  random_prefix = generate_random_string(random_length)
  static_key_ecb(random_prefix + message)
end

def find_last_character(target, snip, round)
  matched_letter = ''

  10.upto(126) do |n|
    test_letter = n.chr
    full_block = snip + test_letter

    current_try = false
    until detect_prefix_size(current_try, 16)
      current_try = random_prefix_ecb(full_block)
    end

    testblock = current_try.scan(/.{16}/m)[round]
    if target == testblock
      matched_letter = test_letter
      break
    end
  end

  return matched_letter
end


#### main

block_size = 16
# attacker input has 2 identical blocks of 16 bytes for identifying when the random prefix is 16 bytes long
attacker_input = "EAAAAAAAAAAAAAAP" + "EAAAAAAAAAAAAAAP" + "AAAAAAAAAAAAAAA"
target_input   = "EAAAAAAAAAAAAAAP" + "EAAAAAAAAAAAAAAP" + "AAAAAAAAAAAAAAA"

found_text = ''
counter = 3

1.upto(138) do |n|
  target = false
  until detect_prefix_size(target, 16); target = random_prefix_ecb(attacker_input); end

  target_block = target.scan(/.{16}/m)[counter]
  found_text += last_char = find_last_character(target_block, target_input, counter)

  if attacker_input.length == 32
    counter += 1
    attacker_input = "EAAAAAAAAAAAAAAP" + "EAAAAAAAAAAAAAAP" + "AAAAAAAAAAAAAAA"
    target_input = "EAAAAAAAAAAAAAAP" + "EAAAAAAAAAAAAAAP" + "AAAAAAAAAAAAAAA" + found_text
  else
    attacker_input[32] = ''
    target_input[32] = ''
    target_input += last_char
  end
end

puts found_text
