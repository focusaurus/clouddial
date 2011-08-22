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


#Known Limitations
* Error handling! There is slim to none thus far.  If your JSON config
  file is imperfect in any way, stack traces are coming your way
* The spec asked for EC2 Micro instances. Fog doesn't support that
  (yet).  The code we'd have to fix is [here](https://github.com/geemus/fog/blob/b1655ab847c2a822c35198c496affed30f78a71a/lib/fog/aws/models/ec2/flavors.rb)

#Open Issues
* `knife ec2 server list` always shows an empty list.  Need to
  investigate.
* knife bootstrap process is not highly reliable.  Sometimes fails.
    * It hangs at "INFO: Bootstrapping Chef on" and my local workstation
      CPU starts to thrash
    * Also, deleting the EC2 entries in your ~/.ssh/known_hosts may help
      with reliability here
