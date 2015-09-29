
require_relative '../lib/crypto_functions'

###############   Convert hex to base64     ######################
#
# The string:
#   "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
# should produce:
#   "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
#
#######################################################################



hex_str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
target = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"

print "hex conversion base64 string:"
p convert_hex_to_b64(hex_str) == target ? "pass" : "fail"

print "check the reverse, going from base 64 to hex works:"
p convert_b64_to_hex(target) == hex_str ? "pass" : "fail"
