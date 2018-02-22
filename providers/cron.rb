def whyrun_supported?
  true
end

action :create do
  renew_command = "#{node.certbot.executable} renew"
  if new_resource.on_success
    renew_command << " && #{new_resource.on_success}"
  end

  cron "renew letsencrypt certificates" do
    time :monthly
    environment new_resource.environment if new_resource.environment
    path new_resource.path if new_resource.path
    mailto new_resource.mailto if new_resource.mailto

    command renew_command
    action :create
  end
end
