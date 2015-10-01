
require_relative '../lib/crypto_functions'

# Implement PKCS#7 padding

txt = "YELLOW SUBMARINE"
targ = "YELLOW SUBMARINE\x04\x04\x04\x04"

p result = pkcs7_pad(txt, 20)
assert_equal(result, targ)
