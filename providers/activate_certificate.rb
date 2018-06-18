def whyrun_supported?
  true
end

action :install do
  directory current_dir do
    owner "root"
    group "root"
    mode 0755
    recursive true

    action :create
  end

  link fullchain_path do
    to new_resource.fullchain_path
  end

  link key_path do
    to new_resource.key_path
  end
end

def domain
  new_resource.domain || new_resource.name
end

def current_dir
  certbot_current_directory(domain)
end

def key_path
  certbot_current_key_path_for(domain)
end

def fullchain_path
  certbot_current_fullchain_path_for(domain)
end
