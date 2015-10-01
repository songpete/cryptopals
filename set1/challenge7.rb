
require 'base64'
require_relative '../lib/encryption'

# AES in ECB mode


b64text = File.read("../lib/7.txt")
decoded = Base64.decode64(b64text)

puts decrypt_ecb(decoded, "YELLOW SUBMARINE")
