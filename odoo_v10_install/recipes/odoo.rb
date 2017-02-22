#
# Cookbook Name:: odoo_v10_install
# Recipe:: odoo
#
# Copyright (c) 2016 Michael Doederlein, All Rights Reserved.

Chef::Log.info("********** running odoo_v10_install::odoo.rb **********")

# make directory for custom addons
execute 'mkdir-custom-add' do
  user node['install_odoo']['user']
  group node['install_odoo']['group']
  command "mkdir -p #{node['install_odoo']['custom_addons']}"
  not_if { File.exist?("#{node['install_odoo']['custom_addons']}") }
end

# add log-path
directory '/var/log/odoo' do
  owner node['install_odoo']['user']
  group 'root'
end

# create odoo-server.conf from template file
template '/etc/odoo-server.conf' do
  source 'odoo-server.conf.erb'
  owner node['install_odoo']['user']
  group 'root'
  mode '0640'
end
# configure ip address in odoo-server.conf for xmlrpc_interface
#execute "ip-conf" do
#  command 'sed -i "s/local-ipv4/$(curl http://169.254.169.254/latest/meta-data/local-ipv4)/g" /etc/odoo-server.conf'
#end

# create start-/stop script
template '/etc/init.d/odoo-server' do
  source 'odoo-server.erb'
  mode '0755'
end

# create service conf
template '/etc/systemd/system/odoo-server.service' do
  source 'odoo-server.serivce.erb'
  mode '0644'
end

# enable odoo service
service 'odoo-server' do
  supports :status => true, :start => true, :stop => true, :restart => true
  action :enable
end

Chef::Log.info("********** starting odoo Server XXXXX **********")
# start odoo service
service 'odoo-server' do
  action :restart
end
