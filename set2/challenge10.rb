require_relative '../lib/encryption'


# Implement CBC mode

str = File.read('../lib/10.txt')
key = "YELLOW SUBMARINE"
iv = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

decoded = Base64.decode64(str)
puts decrypt_cbc(decoded, key, iv)

