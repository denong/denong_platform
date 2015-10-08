require 'openssl'
require "base64"
require "cgi"

class EncryptRsa

  def test
    # Encoding
    cc = File.read("private_key3.pem")
    p cc
    priv_key = OpenSSL::PKey::RSA.new(File.read("private_key3.pem"))
    # sign = Base64.encode64(priv_key.sign(OpenSSL::Digest::DSS1.digest("ruby")))
    sign = Base64.encode64(priv_key.sign("sha1", "ruby".force_encoding("utf-8")))
    puts sign.inspect

    # Decoding
    # puts priv_key.sysverify(OpenSSL::Digest::DSS1.digest("ruby"),Base64.decode64(sign))
  end

  # 创建公钥私钥对
  def create_key path
    key = OpenSSL::PKey::RSA.new 1024
    FileUtils.makedirs(path) unless File.exist?(path)
    File.open("#{path}/private_key3.pem", 'w') { |io| io.write key.to_pem }
    File.open("#{path}/public_key3.pem", 'w') { |io| io.write key.public_key.to_pem }
  end

  def self.encode str, path
    rsa = OpenSSL::PKey::RSA.new File.read(path)
    encrypted = Base64.encode64(rsa.sign("sha1", str.force_encoding("utf-8"))).gsub("\n","")
    string = CGI.escape(encrypted)
    string
  end

  def self.verify encrypted, origin_string, path
    # encrypted = CGI.unescape encrypted
    p "encrypted: #{encrypted}"
    p "origin_string: #{origin_string}"
    encrypted = Base64.decode64 encrypted
    rsa = OpenSSL::PKey::RSA.new File.read(path)
    rsa.verify("sha1", encrypted, origin_string)
  end

  def self.process(str, path)
    pri = OpenSSL::PKey::RSA.new File.read(path)
    sign = pri.sign("sha1", str)
    # sign = pri.sign("sha1", str.force_encoding("utf-8"))
    sign = Base64.encode64(sign)

    # puts "sign is : #{sign.unpack('H*').first}"

    # pub = OpenSSL::PKey::RSA.new File.read('public_key4.pem')
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

  def self.generate_public_key_by_string string
    string = string.insert(192, "\n").insert(128, "\n").insert(64, "\n")
    string
  end

  def initialize()
    @private_key = File.read('private_key3.pem')#.gsub("\\n", "\n")
    @public_key = File.read('public_key3.pem')
    # @public_key = public_key.gsub("\\n", "\n")
    nil
  end

  # 私密加密
  def private_encrypt(value)
    rsa_private_encrypt(value, @private_key)
  end

  # 私密解密
  def private_decrypt(value)
    rsa_private_decrypt(value, @private_key)
  end

  # 公密加密
  def public_encrypt(value)
    rsa_public_encrypt(value, @public_key)
  end

  # 公密解密
  def public_decrypt(value)
    rsa_public_decrypt(value, @public_key)
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
