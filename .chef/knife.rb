current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
#These values need to be changed for your Opscode Platform configuration
node_name                "focusaurus"
client_key               "#{current_dir}/focusaurus.pem"
validation_client_name   "plllc-validator"
validation_key           "#{current_dir}/plllc-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/plllc"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
# Rackspace:
knife[:rackspace_api_key]  = "YourLongHexAPIKeyGoesHere"
knife[:rackspace_api_username] = "yourusername"
# EC2:
# All caps hex string from AWS management console
knife[:aws_access_key_id]     = "YOUR_ACCESS_KEY"
knife[:aws_secret_access_key] = "YOUR_SECRET_ACCESS_KEY"
