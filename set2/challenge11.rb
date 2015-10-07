require_relative '../lib/encryption.rb'

# An ECB/CBC detection oracle
type = detect_ecb_or_cbc(method(:encryption_oracle))

puts "Running #{type} encryption."
