require "openssl"

def certbot_self_signed_directory(domain)
  ::File.join(
    node["certbot"]["working_dir"],
    "self_signed",
    domain
  )
end

def certbot_self_signed_cert_path_for(domain)
  ::File.join(certbot_self_signed_directory(domain), "cert.pem")
end

def certbot_self_signed_key_path_for(domain)
  ::File.join(certbot_self_signed_directory(domain), "key.pem")
end

def certbot_self_signed_pair
  key = OpenSSL::PKey::RSA.new(node["certbot"]["rsa_key_size"])
  public_key = key.public_key

  subject = "/C=BE/O=Test/OU=Test/CN=Test"

  cert = OpenSSL::X509::Certificate.new
  cert.subject = cert.issuer = OpenSSL::X509::Name.parse(subject)
  cert.not_before = Time.now
  cert.not_after = Time.now + 365 * 24 * 60 * 60
  cert.public_key = public_key
  cert.serial = 0x0
  cert.version = 2

  ef = OpenSSL::X509::ExtensionFactory.new
  ef.subject_certificate = cert
  ef.issuer_certificate = cert
  cert.extensions = [
    ef.create_extension("basicConstraints","CA:TRUE", true),
    ef.create_extension("subjectKeyIdentifier", "hash"),
  ]
  cert.add_extension ef.create_extension("authorityKeyIdentifier",
                                         "keyid:always,issuer:always")

  cert.sign key, OpenSSL::Digest::SHA1.new

  [key.to_pem, cert.to_pem]
end
