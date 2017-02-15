def certbot_current_directory(domain)
  ::File.join(
    node["certbot"]["working_dir"],
    "current",
    domain
  )
end

def certbot_current_cert_path_for(domain)
  ::File.join(certbot_current_directory(domain), "cert.pem")
end

def certbot_current_fullchain_path_for(domain)
  ::File.join(certbot_current_directory(domain), "fullchain.pem")
end

def certbot_current_key_path_for(domain)
  ::File.join(certbot_current_directory(domain), "key.pem")
end
