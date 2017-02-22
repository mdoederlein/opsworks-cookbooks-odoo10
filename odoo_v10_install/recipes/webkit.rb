# Cookbook Name:: odoo_v10_install
# Recipe:: install_packages
#
# Copyright (c) 2016 Michael Doederlein, All Rights Reserved.
Chef::Log.info("********** running odoo_v10_install::webkit.rb **********")

# download webkit
execute 'wget-download' do
  cwd '/tmp'
  command "wget #{node['install_odoo']['webkit_url']}/#{node['install_odoo']['webkit_package']}"
  not_if { File.exist?("/tmp/#{node['install_odoo']['webkit_package']}") }
end

# install webkit
execute "install-wkthmltox" do
  command "dpkg -i /tmp/#{node['install_odoo']['webkit_package']}"
#  returns [0, 1]
end

# copy webkit to target location
execute 'copy-files' do
  command 'cp /usr/local/bin/wkhtmltopdf /usr/bin && cp /usr/local/bin/wkhtmltoimage /usr/bin'
  not_if { File.exist?("/usr/bin/wkhtmltopdf") }
end

# clearance
execute 'delete-sources' do
  command "rm '/tmp/#{node['install_odoo']['webkit_package']}'"
  only_if { File.exist?("/tmp/#{node['install_odoo']['webkit_package']}") }
end
