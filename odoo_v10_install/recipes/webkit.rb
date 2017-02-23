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

# unpack webkit
execute "unpack-wkthmltox" do
  command "tar xvfJ /tmp/#{node['install_odoo']['webkit_package']}"
#  returns [0, 1]
end

# copy webkit to target location and some soft links
execute 'copy-files' do
  command 'cp /tmp/wkhtmltopdf/wkhtmltox/bin/wkhtmltopdf /usr/bin && cp /tmp/wkhtmltopdf/wkhtmltox/bin/wkhtmltoimage /usr/bin'
  not_if { File.exist?("/usr/bin/wkhtmltopdf") }
end
link '/usr/bin/wkhtmltopdf' do
  to '/usr/local/bin/wkhtmltopdf'
end
link '/usr/bin/wkhtmltoimage' do
  to '/usr/local/bin/wkhtmltoimage'
end

# clearance
execute 'delete-sources' do
  command "rm '/tmp/#{node['install_odoo']['webkit_package']}'"
  only_if { File.exist?("/tmp/#{node['install_odoo']['webkit_package']}") }
end
