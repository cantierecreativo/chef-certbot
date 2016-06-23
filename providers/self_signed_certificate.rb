action :create do
  directory certificate_dir do
    owner "root"
    group "root"
    mode 0755
    recursive true

    action :create
  end

  if new_resource.force_install || !::File.exists?( self_signed_key_path )
    key, cert = certbot_self_signed_pair

    file self_signed_key_path do
      owner "root"
      group "root"
      mode 0644
      content key

      action :create
    end

    file self_signed_cert_path do
      owner "root"
      group "root"
      mode 0644
      content cert

      action :create
    end

    certbot_activate_certificate new_resource.domain do
      cert_path self_signed_cert_path
      key_path self_signed_key_path
    end
  end
end

def certificate_dir
  @certificate_dir ||= certbot_self_signed_directory(new_resource.domain)
end

def self_signed_key_path
  certbot_self_signed_key_path_for(new_resource.domain)
end

def self_signed_cert_path
  certbot_self_signed_cert_path_for(new_resource.domain)
end
