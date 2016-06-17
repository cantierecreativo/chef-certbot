def letsencrypt_certificates_dir(domain)
  ::File.join("", "etc", "letsencrypt", "live", domain)
end

def letsencrypt_cert_path(domain)
  ::File.join(letsencrypt_certificates_dir(domain), "cert.pem")
end

def letsencrypt_chain_path(domain)
  ::File.join(letsencrypt_certificates_dir(domain), "chain.pem")
end

def letsencrypt_fullchain_path(domain)
  ::File.join(letsencrypt_certificates_dir(domain), "fullchain.pem")
end

def letsencrypt_privatekey_path(domain)
  ::File.join(letsencrypt_certificates_dir(domain), "privkey.pem")
end
