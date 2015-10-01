
require_relative '../lib/encryption'

# Detect AES in ECB mode

hxfile = File.read("../lib/8.txt")
ecb_encoded = ''
line_count = 1


hxfile.each_line do |ln|
  if ecb_encrypted?(ln)
    ecb_encoded = ln.strip
    break
  end
  line_count += 1
end

if ecb_encoded.length > 2
  puts "line number #{line_count} encrypted with ecb:"
  puts ecb_encoded
else
  puts "No ecb encryption was detected"
end
