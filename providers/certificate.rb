action :create do
  directory well_known_dir do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end

  cert_command = "#{base_command} #{domain_arg} #{webroot_arg} #{renew_arg} #{test_arg} #{rsa_size_arg}"

  execute "letsencrypt-certonly" do
    command "#{cert_command} --email #{new_resource.email} --agree-tos"
  end

  if new_resource.install_cron
    cron "renew_#{new_resource.domain}" do
      time new_resource.frequency
      user 'root'
      command "#{cert_command} && servige nginx restart"
      action :create
    end
  end

  certbot_activate_certificate new_resource.domain do
    key_path certbot_privatekey_path_for(new_resource.domain)
    cert_path certbot_cert_path_for(new_resource.domain)
  end
end

def test_arg
  "--test-cert" if new_resource.test
end

def renew_arg
  case new_resource.renew_policy
  when :renew_by_default then "--renew-by-default"
  when :keep_until_expiring then "--keep-until-expiring"
  end
end

def rsa_size_arg
  "--rsa-key-size #{node['certbot']['rsa_key_size']}"
end

def webroot_arg
  "--webroot -w #{webroot_dir}"
end

def domain_arg
  "--domain #{new_resource.domain}"
end

def base_command
  "#{node[:certbot][:executable]} certonly --non-interactive"
end

def webroot_dir
  certbot_webroot_path_for new_resource.domain
end

def well_known_dir
  "#{webroot_dir}/.well-known"
end
