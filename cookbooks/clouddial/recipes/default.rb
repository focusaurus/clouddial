require 'rubygems'
require 'json'

CONF_PATH = '/tmp/clouddial_conf.json'

ruby_block "install_packages" do
  block do
    if not File.exist? CONF_PATH
      puts "Error: Configuration file #{CONF_PATH} not found."
      next
    end
    puts "Chef::Resource::Package is: #{Chef::Resource::Package}"
    puts "Reading package list from JSON at #{CONF_PATH}"
    conf = JSON.parse IO.read CONF_PATH
    #TODO we need to support both APT packages and TGZ.
    #Only handling APT currently
    packages = conf['packages'].select {|p| p['type'] == 'APT'}
    package_names = packages.map {|p| p['name']}
    if conf['post_command']
      puts "Running post_command: #{conf['post_command']}"
      system conf['post_command']
    end

    package_names.each do |pkg|
      package pkg do
        action :install
      end
    end
  end
end

cookbook_file CONF_PATH do
  source File.basename CONF_PATH
  mode '0444'
  backup false
  notifies :create, "ruby_block[install_packages]"
end
