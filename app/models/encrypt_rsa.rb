require 'openssl'
require "base64"
require "cgi"

class EncryptRsa

  def self.test
    # Encoding
    priv_key = OpenSSL::PKey::RSA.new(File.read("private_key3.pem"))
    # sign = Base64.encode64(priv_key.sign(OpenSSL::Digest::DSS1.digest("ruby")))
    sign = Base64.encode64(priv_key.sign("sha1", "ruby".force_encoding("utf-8")))
    puts sign.inspect

    # Decoding
    puts priv_key.sysverify(OpenSSL::Digest::DSS1.digest("ruby"),Base64.decode64(sign))
  end

  # 创建公钥私钥对
  def self.create_key
    key = OpenSSL::PKey::RSA.new 1024

    File.open('private_key3.pem', 'w') { |io| io.write key.to_pem }
    File.open('public_key3.pem', 'w') { |io| io.write key.public_key.to_pem }
  end


  def self.process(str)
    pri = OpenSSL::PKey::RSA.new File.read('private_key_pkcs8.pem')
    sign = pri.sign("sha1", str.force_encoding("utf-8"))
    sign = Base64.encode64(sign)
    # puts "sign is : #{sign.unpack('H*').first}"

    # pub = OpenSSL::PKey::RSA.new File.read('public_key3.pem')
    # result = pub.verify("sha1", sign, str.force_encoding("utf-8"))
    # puts "verify #{result ? 'successful!' : 'failed!'}"
    # sign.unpack('H*').first
    sign
  end

  def change
    str = File.read('key.txt')
    # str = File.read('public_key.pem')
    key = ""
    str = Base64.decode64 str
    str.split(//).each do |e|
      a = e.unpack('H*').to_a
      key << a[0]
    end
    p key
  end

  def initialize()
    # num = 1024 if num < 32
    # rsa = OpenSSL::PKey::RSA.new(num)
    # @public_key = rsa.public_key.to_pem
    # @private_key = rsa.to_pem
    @private_key = File.read('private_key.pem')#.gsub("\\n", "\n")
    # @private_key = private_key
    @public_key = File.read('public_key.pem')
    # @public_key = public_key.gsub("\\n", "\n")
    nil
  end

  # 私密加密
  def private_encrypt(value)
    rsa_private_encrypt(value, @private_key)
  end

  # 私密解密
  def private_decrypt(value)
    rsa_public_decrypt(value, @public_key)
  end

  # 公密加密
  def public_encrypt(value)
    rsa_public_encrypt(value, @public_key)
  end

  # 公密解密
  def public_decrypt(value)
    rsa_private_decrypt(value, @private_key)
  end

  private

  def rsa_private_encrypt(value, rsakey)
    rsa = OpenSSL::PKey::RSA.new(rsakey)
    rsa.private_encrypt(value)
  end

  def rsa_private_decrypt(value, rsakey)
    rsa = OpenSSL::PKey::RSA.new(rsakey)
    rsa.private_decrypt(value)
  end

  def rsa_public_encrypt(value, publickey)
    rsa = OpenSSL::PKey::RSA.new(publickey)
    rsa.public_encrypt(value)
  end

  def rsa_public_decrypt(value, publickey)
    rsa = OpenSSL::PKey::RSA.new(publickey)
    rsa.public_decrypt(value)
  end
end
