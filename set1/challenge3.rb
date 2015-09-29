
require_relative '../lib/crypto_functions'
require_relative '../lib/scoring'

##########################################################################################################
# #3. Single-byte XOR cipher
# The hex encoded string:
#
# 1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736
# ... has been XOR'd against a single character. Find the key, decrypt the message.
#
# You can do this by hand. But don't: write code to do it for you.
#
# How? Devise some method for "scoring" a piece of English plaintext. Character frequency is a good metric.
# Evaluate each output and choose the one with the best score.
##########################################################################################################



cipher = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
all_letters = ('a'..'z').to_a + ('A'..'Z').to_a
max_score = 0
max_letter = ''
max_string = ''

all_letters.each do |l|
  hexkey = string_to_hex(l)
  hexkey = hexkey * 34  # two letters per hex, cipher is 68 length

  xor_result = xor_hex_strings(cipher, hexkey)
  string_result = hex_to_text(xor_result)
  score = score_text(string_result)

    # uncomment line below to see each letter, score and result string
    # p "score #{score} - #{string_result}"

  if score > max_score
    max_score = score
    max_letter = l
    max_string = string_result
  end
end

puts "Max scoring letter is: #{max_letter}"
puts "Result: #{max_string}"
puts "Score: #{max_score}"

puts string_to_hex("qwerty");
