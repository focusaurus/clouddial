conf = data_bag_item('clouddial_conf', 'conf')['value']

#TODO we need to support both APT packages and TGZ.
#Only handling APT currently
packages = conf['packages'].select {|p| p['type'] == 'APT'}
package_names = packages.map {|p| p['name']}
package_names.each do |pkg|
  package pkg do
    action :install
  end
end

post_command = conf['post_command']
if post_command
  execute 'post_command' do
    command post_command
  end
end
