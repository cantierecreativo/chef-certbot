action :create do
  dir = certbot_self_signed_directory(new_resource.domain)
  directory dir do
    owner "root"
    group "root"
    mode 0755
    recursive true

    action :create
  end

  key, cert = certbot_self_signed_pair

  file ::File.join(dir, "key.pem") do
    owner "root"
    group "root"
    mode 0644
    content key

    action :create
  end

  file ::File.join(dir, "cert.pem") do
    owner "root"
    group "root"
    mode 0644
    content cert

    action :create
  end
end
