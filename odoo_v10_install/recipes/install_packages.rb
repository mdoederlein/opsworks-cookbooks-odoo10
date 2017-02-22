# Cookbook Name:: odoo_v10_install
# Recipe:: install_packages
#
# Copyright (c) 2016 Michael Doederlein, All Rights Reserved.
Chef::Log.info("********** running odoo_v10_install::install_packages.rb **********")

# generate target location for odoo git-repository
directory '/opt/odoo' do
  owner node['install_odoo']['user']
  group node['install_odoo']['group']
end
# sync git repository from GitHub
git "#{node['install_odoo']['homedir']}/odoo-server" do
  user node['install_odoo']['user']
  group node['install_odoo']['group']
  depth 1
  repository node['install_odoo']['git_odoo_repository']
  revision node['install_odoo']['git_odoo_branch']
  action :sync
end

# install apt packages
package ['gcc', 'unzip', 'python-pychart', 'wget', 'git', 'python-pip', 'python-imaging', 'python-setuptools', 'python-dev', 'libxslt-dev', 'libxml2-dev', 'libldap2-dev', 'libsasl2-dev', 'node-less', 'postgresql-server-dev-all', 'nodejs', 'npm', 'libtiff5-dev', 'libjpeg8-dev', 'zlib1g-dev', 'libfreetype6-dev', 'liblcms2-dev', 'libwebp-dev', 'tcl8.6-dev', 'tk8.6-dev', 'python-tk']

# packages for webkit
package ['fontconfig', 'libfontconfig1', 'libx11-6', 'libxext6', 'libxrender1', 'xfonts-base', 'xfonts-75dpi']

# install node packages
execute 'npm-packages' do
  command 'npm install -g less less-plugin-clean-css'
end

link '/usr/bin/node' do
  to '/usr/bin/nodejs'
end

# install further requirements
#execute 'pip-update' do
#  command 'easy_install --upgrade pip'
#end

#execute 'pip-install' do
#  execute 'pip install BeautifulSoup BeautifulSoup4 passlib pillow dateutils polib unidecode flanker simplejson enum py4j'
#end

execute 'pip-install' do
  command 'pip install -r /opt/odoo/odoo-server/requirements.txt'
  not_if 'pip list | awk \'{print $1}\' | grep xlwt'
end
#execute 'easy_install' do
# scheinbar ist das Verzeichnis pyPdf vorhanden, auch wenn easy_install nicht gelaufen ist -> pr�fen!
#  command 'easy_install pyPdf vatnumber pydot psycogreen suds ofxparse'
#  not_if { File.exist?("/usr/local/lib/python2.7/dist-packages/pyPdf") }
#end