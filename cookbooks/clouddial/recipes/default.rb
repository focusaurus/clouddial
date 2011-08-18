require 'rubygems'
require 'json'
packages_path = '/tmp/clouddial_packages.json'
cookbook_file packages_path do
  source "clouddial_packages.json"
  mode "0444"
end
log "BUGBUG clouddial version 3 running"
packages = ["nginx", "monit"]
if File.exist? packages_path
  log "Reading package list from JSON at #{packages_path}"
  packages = JSON.parse IO.read packages_path
else
  log 'JSON not found, using hard coded package list'
end
packages.each do |pkg|
  package pkg do
    action :install
  end
end
