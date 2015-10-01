require 'openssl'

def decrypt_ecb(str, key)
  decipher = OpenSSL::Cipher.new('AES-128-ECB')
  decipher.decrypt
  decipher.key = key

  return (decipher.update(str) + decipher.final)
end
