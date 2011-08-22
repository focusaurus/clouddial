#!/usr/bin/env ruby
#
require 'FileUtils'

def command_sample_creds
  FileUtils.cp ".chef/knife.rb.SAMPLE", ".chef/knife.rb"
end

def command_real_creds
  FileUtils.cp ".chef/knife.rb.REAL", ".chef/knife.rb"
end

def command_upload
    system <<-EOF
knife cookbook upload clouddial
knife data bag from file clouddial_conf \
  data-bags/clouddial_conf.json
EOF
end

def command_clean
    FileUtils.rm_rf './results'
end

def command_list
    system <<-EOF
knife ec2 server list --region us-west-1 | grep -v "is deprecated"
knife node list
EOF
end

def command_delete(names)
    names.each do |name|
        command = "knife node delete '#{name}' --yes"
        if name.start_with? 'i-'
            command = "knife ec2 server delete '#{name}' --region us-west-1 --yes"
        end
        system command
    end
end

command = ARGV[0]
command_symbol = ('command_' + command).to_sym
if self.private_methods.include? command_symbol
    if ARGV.size > 1
        self.send command_symbol, ARGV[1..-1]
    else
        self.send command_symbol
    end
else
    puts "Unknown command #{command}"
    puts "Valid commands: #{Commands.keys.sort}"
end
