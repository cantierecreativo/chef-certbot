#
# Cookbook Name:: certbot
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "letsencrypt" do
  action :install
end

directory node["certbot"]["working_dir"] do
  owner "root"
  group "root"
  mode 0755
  recursive true

  action :create
end
