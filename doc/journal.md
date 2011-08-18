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
* PIN is 2486 but their IVR is just not accepting it

Thursday, August 18, 2011 11:21 AM MDT
* OK AWS account is verified
* I have an access key, cert, key pair

Thursday, August 18, 2011 11:27 AM MDT
* My chef stuff lives in ~/projects/chef-repo and ~/projects/knife.rb
* To activate the right ruby for my chef setup
    rvm use ruby-1.9.2-p180
* 
