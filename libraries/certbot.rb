require 'openssl'

def certbot_certificates_dir(domain)
  ::File.join("", "etc", "certbot", "live", domain)
end

def certbot_cert_path_for(domain)
  ::File.join(certbot_certificates_dir(domain), "cert.pem")
end

def certbot_chain_path_for(domain)
  ::File.join(certbot_certificates_dir(domain), "chain.pem")
end

def certbot_fullchain_path_for(domain)
  ::File.join(certbot_certificates_dir(domain), "fullchain.pem")
end

def certbot_privatekey_path_for(domain)
  ::File.join(certbot_certificates_dir(domain), "privkey.pem")
end

def certbot_webroot_path_for(domain)
  ::File.join(node[:certbot][:webroot_dir], domain)
end

def certbot_well_known_path_for(domain)
  ::File.join(certbot_webroot_path_for(domain), ".well-known")
end
