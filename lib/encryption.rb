require 'openssl'
require_relative 'crypto_functions'

def encrypt_ecb(str, key)
  cipher = OpenSSL::Cipher.new('AES-128-ECB')
  cipher.encrypt
  cipher.key = key

  return (cipher.update(str) + cipher.final)
end

def decrypt_ecb(str, key)
  decipher = OpenSSL::Cipher.new('AES-128-ECB')
  decipher.decrypt
  decipher.key = key

  return (decipher.update(str) + decipher.final)
end

# Detect if ecb encrypted. Same text always encrypts to same cipher. Break into blocks of size 16 and look for duplicates?
def ecb_encrypted?(cipher)
  line_parts = cipher.scan(/.{16}/)
  line_parts.detect { |e| line_parts.count(e) > 1 } ? true : false
end

# ECB without the final block (so it can be used to implement CBC)
def encrypt_ecb_nofinal(msg, key)
  cipher = OpenSSL::Cipher.new('AES-128-ECB')
  cipher.encrypt
  cipher.key = key
  return cipher.update(msg)
end

def decrypt_ecb_nofinal(str, key)
  decipher = OpenSSL::Cipher.new('AES-128-ECB')
  decipher.decrypt
  decipher.padding = 0
  decipher.key = key
  return decipher.update(str)
end

def encrypt_cbc(plaintext, key, iv)
  str = pkcs7_pad(plaintext, key.length)
  counter = 0
  output = ''
  last_cipherblock = iv

  str.scan(/.{16}/m) do |block|
    ecb_input = repeat_key_xor(block, last_cipherblock)
    output << last_cipherblock = encrypt_ecb_nofinal(ecb_input, key)
  end
  return output
end

def decrypt_cbc(cipher, key, iv)
  last_cipherblock = iv
  plaintext = ''

  cipher.scan(/.{16}/m) do |block|
    ecb_output = decrypt_ecb_nofinal(block, key)
    plaintext << repeat_key_xor(ecb_output, last_cipherblock)
    last_cipherblock = block
  end
  return remove_pkcs7_padding(plaintext)
end
