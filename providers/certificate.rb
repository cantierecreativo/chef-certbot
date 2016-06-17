action :create do
  package "letsencrypt" do
    action :install
  end

  directory well_known_dir do
    owner "root"
    group "root"
    mode 755
    recursive true
  end

  template "/etc/nginx/sites-enabled/letsencrypt-#{new_resource.domain}.conf" do
    source "nginx_letsencrypt.erb"
    owner "root"
    group "root"
    mode 0644
    variables(domain: new_resource.domain, webroot_dir: webroot_dir)
    notifies :restart, "service[nginx]", :immediately
    cookbook "certbot"
  end

  service "nginx" do
    action :nothing
  end

  cert_command = "#{base_command} #{domain_arg} #{webroot_arg} #{renew_arg} #{test_arg}"

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

def webroot_arg
  "--webroot -w #{webroot_dir}"
end

def domain_arg
  "--domain #{new_resource.domain}"
end

def base_command
  "/usr/bin/letsencrypt certonly --non-interactive"
end

def webroot_dir
  "/var/www/letsencrypt/#{new_resource.domain}"
end

def well_known_dir
  "#{webroot_dir}/.well-known"
end
