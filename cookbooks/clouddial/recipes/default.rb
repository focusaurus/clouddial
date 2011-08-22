conf = data_bag_item('clouddial_conf', 'conf')['value']

#Note it might be clearer to install packages in order regardless of type
#but for now this is acceptable

#Install any APT packages
apt_packages = conf['packages'].select {|p| p['type'] == 'APT'}
apt_names = apt_packages.map {|p| p['name']}
apt_names.each do |pkg|
  package pkg do
    action :install
  end
end

#Install any TGZ packages
tgz_packages = conf['packages'].select {|p| p['type'] == 'TGZ'}
tgz_packages.each do |pkg|
  bash "Install S3 tarball #{pkg['name']}" do
    #TODO stricter path sanitization. Find the ruby equivalent of python's
    #commands.mkarg
    path = "'/tmp/#{pkg['name']}.tar.gz'"
    tmp_code = <<-EOF
    #TODO AWS S3 authentication token integration
    curl -s --output #{path} '#{pkg['URL']}'
    #Only delete the package if it successfully extracts
    tar xvzf #{path} -C / && rm -f #{path}
    EOF
    code tmp_code
  end
end

post_command = conf['post_command']
if post_command
  bash 'post_command' do
    code "mkdir /tmp/rg_results\n" + post_command
  end
end
