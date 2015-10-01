require 'openssl'

def decrypt_ecb(str, key)
  decipher = OpenSSL::Cipher.new('AES-128-ECB')
  decipher.decrypt
  decipher.key = key

  return (decipher.update(str) + decipher.final)
end

# Detect if ecb encrypted. Break into blocks of size 16 and look for duplicates?
def ecb_encrypted?(cipher)
  line_parts = cipher.scan(/.{16}/)
  line_parts.detect { |e| line_parts.count(e) > 1 } ? true : false
end

