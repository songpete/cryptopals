
require_relative '../lib/encryption.rb'

describe 'byte hamming distance' do
  it 'should give the correct number of differing bits between two bytes' do
    expect(byte_hamming_distance(97, 98)).to eq(2)
    expect(byte_hamming_distance(134, 51)).to eq(5)
  end
end

describe 'string hamming distance' do
  it 'should give the correct hamming distance for two strings' do
    str1 = "this is a test"
    str2 = "wokka wokka!!!"

    expect(string_hamming_distance(str1, str2)).to eq(37)
  end
end

describe 'nest into columns function' do
  it 'should convert an array into one that is nested' do
    array1 = ["a","b","c","d","e","f","g","h","i","j","k","l"]
    target1 = [["a","d","g","j"], ["b","e","h","k"], ["c","f","i","l"]]
    target2 = [["a","e","i"], ["b","f","j"], ["c","g","k"], ["d","h","l"]]

    expect(nest_into_columns(array1, 3)).to eq(target1)
    expect(nest_into_columns(array1, 4)).to eq(target2)
  end

  it 'should handle cases when the length is not a multiple of requested number of columns' do
    array1 = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n"]
    target1 = [["a","d","g","j","m"], ["b","e","h","k","n"], ["c","f","i","l"]]

    expect(nest_into_columns(array1, 3)).to eq(target1)
  end
end

describe 'pkcs7 padding' do
  it 'should add proper padding' do
    str = "YELLOW SUBMARINE"

    expect(pkcs7_pad(str, 20)).to eq("YELLOW SUBMARINE\x04\x04\x04\x04")
    expect(pkcs7_pad(str, 23)).to eq("YELLOW SUBMARINE\x07\x07\x07\x07\x07\x07\x07")
  end

  it 'should not alter a string that is the same width as specified length' do
    expect(pkcs7_pad("YELLOW SUBMARINE AND DOLPHINS", 29)).to eq("YELLOW SUBMARINE AND DOLPHINS")
  end
end

describe 'ecb encryption and decryption' do
  str = "This is a secret message. Keep it safe from prying eyes and all that."
  key = "YELLOW SUBMARINE"

  it 'should encrypt and decrypt to original message with same key' do
    cipher = encrypt_ecb(str, key)
    expect(decrypt_ecb(cipher, key)).to eq(str)
  end
end

describe 'cbc encryption and decryption' do 
  str = "This is a secret message. Keep it safe from prying eyes and all that."
  key = "YELLOW SUBMARINE"
  iv = "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

  it 'should encrypt and decrypt to original message with same key' do
    cipher = encrypt_cbc(str, key, iv)
    expect(decrypt_cbc(cipher, key, iv)).to eq(str)
  end
end
