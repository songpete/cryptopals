
require_relative '../lib/encryption'

# ECB cut-and-paste


STATIC_KEY = 'aj34jkqi8dggwjmz'

def profile_for(email)
  return false if email.match(/(&|=)/) # don't allow '&' or '=' characters
  "email=#{email}&uid=10&role=user"
end

def values_to_object(string)
  obj = {}
  string.scan(/[^&]*=[^&]*/).each do |res|
    key = res.match(/^[^=]*/).to_s
    val = res.match(/[^=]*$/).to_s
    obj[key] = val
  end
  return obj
end

def profile_encrypt(profile)
  string = pkcs7_pad(profile, 16)
  cipher = OpenSSL::Cipher.new('AES-128-ECB')
  cipher.encrypt
  cipher.key = STATIC_KEY
  return cipher.update(profile)
end

def profile_decrypt_parse(profile)
  decipher = OpenSSL::Cipher.new('AES-128-ECB')
  decipher.decrypt
  decipher.key = STATIC_KEY

  return decipher.update(profile)
end

# samples
p user_profile = profile_for('tupperparty@email.com')
p profile_obj = values_to_object(user_profile)

# reject an attempt to set role=admin
p profile_for('attacker@mail.com&role=admin')

## start an attack
# pass in an email that will set the 2nd block to start with 'admin'
  prof_admin = profile_for("AAAAAAAAAAadmin")

  # encrypt it and take the second block (which starts with the word 'admin')
  encrypted_prof = profile_encrypt(prof_admin).scan(/.{16}/)   # len 48
  admin_block = encrypted_prof[1]

  # pass in an email that will push the word 'user' as the start of the last block (email should be 13 bytes long)
  user_in_last_block = profile_for("myml@mail.com")

  # split the encrypted string into blocks of size 16
  user_in_third_block = profile_encrypt(user_in_last_block).scan(/.{16}/)

  # replace the third block (which would start with 'user') with the block that starts with word 'admin'
  admin_added_cipher = user_in_third_block[0] + user_in_third_block[1] + admin_block

  # decrypt it to get 'role=admin' (although it duplicates the uid)
  puts ""; p "Decryption result after modification: "
p modified_profile = profile_decrypt_parse(admin_added_cipher + "AAAAAA")

  # attacker has created role => admin
  puts ""; p "Final object: "
p values_to_object(modified_profile)
