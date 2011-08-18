#Cloud Dial Server Provisioning Project
(ReportGrid interview challenge problem)

# Prerequisites
* OpenSSH
* [Opscode Chef](http://wiki.opscode.com/display/chef/Support)
    * rvm (recommended but not strictly required)
    * ruby 1.9
    * Chef 0.9 or newer
* knife-ec2 gem

#Setting up your environment
* Make sure you have ssh installed (everyone does...)
* [Install RVM](http://beginrescueend.com/rvm/install/)
* Use rvm to install ruby and activate it
    rvm install ruby-1.9.2
    rvm use ruby-1.9.2
* Install chef and knife-ec2
    gem install chef knife-ec2 --no-rdoc --no-ri

#Third Party Accounts Required
* Set up an account with the Opscode platform and follow their
  quickstart guide. [http://www.opscode.com/chef/]()
* Amazon Web Services (AWS) Elastic Compute Cloud (EC2)
