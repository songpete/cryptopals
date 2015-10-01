
require_relative '../lib/crypto_functions'


# file 4.txt is from: http://cryptopals.com/static/challenge-data/4.txt
f = File.open("../lib/4.txt", "r")
lowest = 1000
best_key = ''
best_match = ''

f.each_line do |ln|
  key_length = ln.length / 2

  for key in 32..126 do
    l = key.chr
    hexkey = string_to_hex(l)
    hexkey = hexkey * key_length

    xor_result = xor_hex_strings(ln, hexkey)
    string_result = hex_to_text(xor_result)
    # score = score_text(string_result)
    score = score_text_two(string_result)

    if score < lowest
      best_key = l
      lowest = score
      best_match = string_result
    end
  end
end

p "Best score was key #{best_key}, score #{lowest}"
p "result: #{best_match}"
