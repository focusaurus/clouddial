require 'rubygems'
require 'json'

CONF_PATH = '/tmp/clouddial_conf.json'

cookbook_file CONF_PATH do
  source File.basename CONF_PATH
  mode '0444'
end

def install_packages
  log "Reading package list from JSON at #{CONF_PATH}"
  conf = JSON.parse IO.read CONF_PATH
  #TODO we need to support both APT packages and TGZ.
  #Only handling APT currently
  packages = conf['packages'].select {|p| p['type'] == 'APT'}
  package_names = packages.map {|p| p['name']}
  if conf['post_command']
    log "Running post_command: #{conf['post_command']}"
    system conf['post_command']
  end

  package_names.each do |pkg|
    package pkg do
      action :install
    end
  end

end

if File.exist? CONF_PATH
  install_packages
else
  log "Error: Configuration file #{CONF_PATH} not found."
end
