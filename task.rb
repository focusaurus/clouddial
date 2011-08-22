#!/usr/bin/env ruby
#
require 'FileUtils'

Commands = {}

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

command_symbols = self.private_methods.select do |m|
  m.to_s.start_with? 'command_'
end
#Store a map of the string command name (no prefix) to the method object
prefix = 'command_'
command_symbols.each do |sym|
  Commands[sym.to_s[prefix.size..-1]] = self.method(sym)
end

command = ARGV[0]
if Commands.include? command
    Commands[command].call
else
    puts "Unknown command #{command}"
    puts "Valid commands: #{Commands.keys.sort}"
end
