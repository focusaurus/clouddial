Thursday, August 18, 2011 10:51 AM MDT
* Basic analysis of problem components
    * Part 1: Create the instances
    * Part 2: OS package installs
    * Part 3: Configure/connect S3 bucket
    * Part 4: tarball package install
    * Part 5: Configuration file to drive script
    * Part 6: Post-install script execution and output gathering
    * Part 7: "Terminate" (presumably delete) the instances
* How to interact with EC2 API
* EC2 credentials, tokens, etc
* Code to create VM instances
* Chef/Ruby?
* Have already done a basic workshop on launching cloud instances with Chef
* Docs are here. [http://wiki.opscode.com/display/chef/Launch+Cloud+Instances+with+Knife]()
* I think first I'll see if I can get that up and running.  I think that should handle the first 2 parts of the challenge.

Thursday, August 18, 2011 11:14 AM MDT
* Going to get an EC account set up
* PIN is XXXX but their IVR is just not accepting it
* OK, it finally worked

Thursday, August 18, 2011 11:21 AM MDT
* OK AWS account is verified
* I have an access key

Thursday, August 18, 2011 11:27 AM MDT
* My chef stuff lives in ~/projects/chef-repo and ~/projects/knife.rb
* To activate the right ruby for my chef setup
    rvm use ruby-1.9.2-p180

Thursday, August 18, 2011 11:54 AM MDT
* AWS account is still pending, can't get key pairs yet
* While that is pending, I'll use rackspace since I already have an active account
* Will probably use this Amazon AMI: http://aws.amazon.com/amis/Linux/4350
* AMI Manifest:	 ubuntu-images/ubuntu-maverick-10.10-amd64-server-20101007.1
* AMI ids
Release 20101007.1

EBS Root
ap-southeast-1: ami-68136d3a
eu-west-1: ami-405c6934
us-east-1: ami-548c783d
us-west-1: ami-ca1f4f8f
Instance Store
ap-southeast-1: ami-64136d36
eu-west-1: ami-505c6924
us-east-1: ami-688c7801
us-west-1: ami-cc1f4f89

Thursday, August 18, 2011 12:08 PM MDT
* While waiting for AWS to start working, will work on a chef cookbook that
can take a dynamic list of packages

Thursday, August 18, 2011 12:15 PM MDT
    ~/projects/chef-repo/cookbooks-> knife cookbook create clouddial                                      plyons@zoot
    ** Creating cookbook clouddial
    ** Creating README for cookbook: clouddial
    ** Creating metadata for cookbook: clouddial

Thursday, August 18, 2011 1:18 PM MDT
* OK, got package list from JSON file working using a Chef cookbook_file resource
* might not be the exact mechanics Kris had in mind, but it's a reasonable start
* Beh, the clouddial_packages.json file is there after we've already looked for it. So it works the second time but not the first.

Thursday, August 18, 2011 1:34 PM MDT
knife ec2 server create [RUN LIST...] (options)
    -Z, --availability-zone ZONE     The Availability Zone
    -A, --aws-access-key-id KEY      Your AWS Access Key ID
    -K SECRET,                       Your AWS API Secret Access Key
        --aws-secret-access-key
    -N, --node-name NAME             The Chef node name for your new node
    -s, --server-url URL             Chef Server URL
    -k, --key KEY                    API Client Key
    -c, --config CONFIG              The configuration file to use
        --defaults                   Accept default values for all questions
    -d, --distro DISTRO              Bootstrap a distro using a template
    -e, --editor EDITOR              Set the editor to use for interactive commands
    -f, --flavor FLAVOR              The flavor of server (m1.small, m1.medium, etc)
    -F, --format FORMAT              Which format to use for output
    -I IDENTITY_FILE,                The SSH identity file used for authentication
        --identity-file
    -i, --image IMAGE                The AMI for the server
    -l, --log_level LEVEL            Set the log level (debug, info, warn, error, fatal)
    -L, --logfile LOGLOCATION        Set the log file location, defaults to STDOUT
    -n, --no-editor                  Do not open EDITOR, just accept the data as is
    -u, --user USER                  API Client Username
        --prerelease                 Install the pre-release chef gems
        --print-after                Show the data after a destructive operation
        --region REGION              Your AWS region
    -G, --groups X,Y,Z               The security groups for this server
    -S, --ssh-key KEY                The AWS SSH key id
    -P, --ssh-password PASSWORD      The ssh password
    -x, --ssh-user USERNAME          The ssh username
        --template-file TEMPLATE     Full path to location of template to use
    -v, --version                    Show chef version
    -y, --yes                        Say yes to all prompts for confirmation
    -h, --help                       Show this message

Thursday, August 18, 2011 1:39 PM MDT
* Generated a new key pair named "primary" in the AWS web console
* stored the private key 0400 in ~/.ssh/aws_primary.pem

Thursday, August 18, 2011 1:42 PM MDT
* Getting this error
http://tickets.opscode.com/browse/KNIFE_EC2-10

Thursday, August 18, 2011 1:47 PM MDT
* Found a good article: [http://www.agileweboperations.com/amazon-ec2-instances-with-opscode-chef-using-knife]()
* knife ec2 server create "clouddial" -i ami-596f3c1c -f t1.micro -S aws_primary -I ~/.ssh/aws_primary.pem --ssh-user ubuntu --region us-west-1 -Z us-west-1
* knife ec2 server create "clouddial" -i ami-596f3c1c -f t1.micro -S aws_primary -I ~/.ssh/aws_primary.pem --ssh-user ubuntu 

Thursday, August 18, 2011 2:08 PM MDT
* OK finally got communication with EC2 working.  I had 2 knife.rb files and was editing the wrong one.
* knife ec2 server list                                                          plyons@zoot
  [WARN] Fog::AWS::Compute.new is deprecated, use Fog::Compute.new(:provider => 'AWS') instead (/Users/plyons/.rvm/gems/ruby-1.9.2-p180/gems/fog-0.8.2/lib/fog/core/service.rb:58:in `new') 
Instance ID      Public IP        Private IP       Flavor           Image            Security Groups  State          

Thursday, August 18, 2011 2:16 PM MDT
knife ec2 server create "clouddial" -i ami-596f3c1c -f m1.small  --region us-west-1        [WARN] Fog::AWS::Compute.new is deprecated, use Fog::Compute.new(:provider => 'AWS') instead (/Users/plyons/.rvm/gems/ruby-1.9.2-p180/gems/fog-0.8.2/lib/fog/core/service.rb:58:in `new') 
Instance ID: i-ebea2eac
Flavor: m1.small
Image: ami-596f3c1c
Availability Zone: us-west-1b
Security Groups: default
SSH Key: 

Waiting for server...................
Public DNS Name: ec2-204-236-158-197.us-west-1.compute.amazonaws.com
  [WARN] Fog::AWS::Compute::Server => #ip_address is deprecated, use #public_ip_address instead (/Users/plyons/.rvm/gems/ruby-1.9.2-p180/gems/fog-0.8.2/lib/fog/compute/models/aws/server.rb:9:in `<class:Server>')
Public IP Address: 204.236.158.197
Private DNS Name: ip-10-176-23-37.us-west-1.compute.internal
Private IP Address: 10.176.23.37

Thursday, August 18, 2011 2:30 PM MDT
* OK, got a server built and sshable
ssh -i ~/.ssh/knife.pem ubuntu@ec2-50-18-4-212.us-west-1.compute.amazonaws.com
Warning: Permanently added 'ec2-50-18-4-212.us-west-1.compute.amazonaws.com,50.18.4.212' (RSA) to the list of known hosts.
Welcome to Ubuntu 11.04 (GNU/Linux 2.6.38-8-virtual i686)

 * Documentation:  https://help.ubuntu.com/

  System information as of Thu Aug 18 20:30:33 UTC 2011

  System load:  0.0              Processes:           60
  Usage of /:   5.2% of 9.84GB   Users logged in:     0
  Memory usage: 1%               IP address for eth0: 10.168.151.148
  Swap usage:   0%

  Graph this data and manage this system at https://landscape.canonical.com/
---------------------------------------------------------------------
At the moment, only the core of the system is installed. To tune the 
system to your needs, you can choose to install one or more          
predefined collections of software by running the following          
command:                                                             
                                                                     
   sudo tasksel --section server                                     
---------------------------------------------------------------------

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@ip-10-168-151-148:~$ A


Thursday, August 18, 2011 2:31 PM MDT
* It seems my aws security group and filter settings didn't save properly in the web console the first time I tried.


knife ec2 server create "clouddial" -i ami-596f3c1c -f m1.small  --region us-west-1 -S knife --ssh-user ubuntu -I ~/.ssh/knife.pem
* That builds the server but SSH auth fails
* ssh works fine from a terminal

Waiting for sshd.done
INFO: Bootstrapping Chef on 
WARN: Failed to connect to ec2-50-18-43-70.us-west-1.compute.amazonaws.com -- Net::SSH::AuthenticationFailed: ubuntu@ec2-50-18-43-70.us-west-1.compute.amazonaws.com

Thursday, August 18, 2011 2:49 PM MDT
* Needed to do ssh-add ~/.ssh/knife.pem in EVERY tmux window where I might run knife
* Now I can bootstrap an AMI image and install arbitrary packages on it


he
ec2-50-18-65-198.us-west-1.compute.amazonaws.com [Thu, 18 Aug 2011 20:51:11 +0000] INFO: Running report handlers
ec2-50-18-65-198.us-west-1.compute.amazonaws.com [Thu, 18 Aug 2011 20:51:11 +0000] INFO: Report handlers complete

Instance ID: i-bdf337fa
Flavor: m1.small
Image: ami-596f3c1c
Availability Zone: us-west-1a
Security Groups: default
SSH Key: knife
Public DNS Name: ec2-50-18-65-198.us-west-1.compute.amazonaws.com
  [WARN] Fog::AWS::Compute::Server => #ip_address is deprecated, use #public_ip_address instead (/Users/plyons/.rvm/gems/ruby-1.9.2-p180/gems/fog-0.8.2/lib/fog/compute/models/aws/server.rb:9:in `<class:Server>')
Public IP Address: 50.18.65.198
Private DNS Name: ip-10-170-17-30.us-west-1.compute.internal
Private IP Address: 10.170.17.30
Run List: clouddial

Thursday, August 18, 2011 2:57 PM MDT
* Confirmed the packages from clouddial/recipies/default.rb got installed
* breaking for lunch
* About 4 hours worked so far (pomodoro technique)

Thursday, August 18, 2011 3:26 PM MDT
* Going to get git up to date then break for today

Friday, August 19, 2011 12:22 PM MDT
* Going to work on the post-install script running and output gathering
* chef should handle concurrency, which is nice

Friday, August 19, 2011 12:47 PM MDT
* Yes! Finally got the magic incantation to get ssh working
    knife ssh name:i-bdf337fa uptime  -i ~/.ssh/knife.pem -a cloud.public_hostname --ssh-user ubuntu

Friday, August 19, 2011 2:28 PM MDT
* Have start of a run.sh script to create the instances and run a post
  command on them
* Sadly, the knife ec2 server create command is not very reliable.
  Sometimes the ssh connection doesn't work and it dies before it
bootstraps chef.

Friday, August 19, 2011 4:16 PM MDT
* OK, got a clue about chef resources and convergence.  I can't believe
  jtimberman didn't explain this during chef hack day
* [http://wiki.opscode.com/display/chef/Anatomy+of+a+Chef+Run]()
