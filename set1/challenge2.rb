
require_relative '../lib/crypto_functions'

##########################################################################################################
# #2. Fixed XOR: Write a function that takes two equal-length buffers and produces their XOR combination.
#
# If your function works properly, then when you feed it the string: "1c0111001f010100061a024b53535009181c"
#   ... after hex decoding, and when XOR'd against: "686974207468652062756c6c277320657965"
#   ... should produce: "746865206b696420646f6e277420706c6179"
##########################################################################################################


feed_str = "1c0111001f010100061a024b53535009181c"
xor_str = "686974207468652062756c6c277320657965"
target_str = "746865206b696420646f6e277420706c6179"

result = xor_hex_strings(feed_str, xor_str)
puts result
puts target_str

# the result and target string should be the same
assert_equal(result, target_str)

