
require_relative '../lib/crypto_functions'
require 'base64'

# break repeating key XOR (Vigenere)


# File is from http://cryptopals.com/static/challenge-data/6.txt. Apparently in base64
cipher = File.read("../lib/6.txt")
decoded_string = ''
Base64.decode64(cipher).each_byte {|b| decoded_string += b.chr }

puts "keysizes with the six lowest hamming scores:"
p keysize_hamming_values = guess_keysize(decoded_string)[0..5]; puts ""
p "Most likely keysize is #{keysize_hamming_values.first[0]} with a hamming value of #{keysize_hamming_values.first[1]}"

key_guess = find_key(decoded_string, keysize_hamming_values[0][0])
p "Possible key is: #{key_guess}"

# xor the cipher against the repeating key and convert from hex to text
puts "Decrypted string based on key: "; puts ""
puts repeat_key_xor(decoded_string, key_guess)
