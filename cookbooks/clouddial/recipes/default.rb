conf = data_bag_item('clouddial_conf', 'conf')['value']

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
    flags '-e'
    #TODO stricter path sanitization. Find the ruby equivalent of python's
    #commands.mkarg
    path = "'/tmp/#{pkg['name']}.tar.gz'"
    tmp_code = <<-EOF
    curl -s --output #{path} '#{pkg['URL']}'
    #Only delete the package if it successfully extracts
    tar xvzf #{path} -C / && rm -f #{path}
    EOF
    out_file = File.open('/tmp/tmp_code.sh', 'w')
    out_file.write tmp_code
    out_file.close
    #TODO authentication token integration
    code tmp_code
  end
end

post_command = conf['post_command']
if post_command
  execute 'post_command' do
    command post_command
  end
end
