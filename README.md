#Cloud Dial Server Provisioning Project
(ReportGrid interview challenge problem)

##Challenge Problem Text with Commentary

Here is the original challange specification with my comments.
<style type="text/css">
.quote {
  background-color: #CCC;
}
</style>

<div class="quote">

> Here is your challenge problem:
> Your challenge consists of building a script for very simple EC2 server
> management. You are welcome to use the command-line tools, 
> third-party EC2 libraries, or the EC2 service APIs directly to complete this
> task.

</div>

* I used 3rd party stuff:
    * The knife-ec2 plugin
    * Opscode Chef
    * knife-ec2 is built on top of the Fog cloud management library

<div class="quote">

> Here's what you script needs to do:
> Given a number n, provision that number of EC2 micro Linux instances. It
> should be possible to provide a simple configuration file (preferably in
> something like JSON, YAML, or an internal Ruby/Python/whatever DSL) that 
> specifies any additional packages that need to be installed as part of the
> configuration process. These packages can be either standard packages
> for the distro (we prefer you focus on dpkg and apt - our servers are
> Ubuntu-based, but handling RPM-based distros would be good too) or .tar.gz 
> zipped binaries following the standard Unix layout conventions 
> (/bin, /lib, /src, etc...). If a binary package of this sort is specified,
> the script should be able to download and install the package from an Amazon
> S3 bucket.

</div>

* run.sh takes the number of instances as the first argument
* The configuration file in JSON format at data-bags/clouddial_conf.json
* Note that the configuration file MUST be up to date in Chef, so use `./task.rb
  upload` to upload it to Chef before running run.sh
* I tested only ubuntu packages, but I believe the code in the `default.rb`
  recipe will also work unmodified for RPMs on RPM-based systems
* S3 bucket needs to be publically accessible for now.  Adding the
  authentication token should
  be straightforward but I didn't tackle that at this time

<div class="quote">

> Once each server is fully configured, run a process (which should also be
> specified in the configuration file) on each system and collect the output.
> The script should be able to handle a relatively long-running process that will
> need to be polled for termination, although for the purpose of this exercise it
> can be something as simple as using curl to retrieve some information from a
> remote service - search Google for ReportGrid or something.

</div>

* I used curl to download the ReportGrid home page.  Chef handles the polling
  for us automatically.
* Output is created in a directory structure under `results` with a subdirectory
  for each target machine named with the machine's FQDN.  Any file(s) put into
`/tmp/rg_results` on the target instance will be transfered to the local results
directory for that instance.

<div class="quote">

> Once the process is complete on all servers (though you can do this
> incrementally) collect the output from all the processes and return it to the
> client. Once all the output is retrieved, terminate the instances.

</div>

* Both the Chef nodes and the EC2 instances are deleted at the end. For
  troubleshooting, this can be disabled by adding a `return 0` as the top line
of the `deleteInstance` function in `run.sh`

> Please publish your solution to a public git repository on GitHub and send us
> the link. Take as long as you need, but please do keep track of how long it
> takes you to write the solution and let us know when you've completed it - the
> faster the better! You are welcome to use your language(s) of choice, and don't
> feel restricted to use just a single language; if parts need to be in shell,
> parts in Ruby, parts in Python, etc so be it.

</div>

* I worked on this over about 4 total sessions between Thursday and Sunday for a
  total of about 17 hours
* It's in ruby and shell



# Prerequisites
* A Unixy client OS (built on OS X. Probably works fine on Linux)
* Bash
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
* Your AWS configuration must have a firewall rule allowing SSH
  connections. [Here is an article with detailed explanations](http://www.agileweboperations.com/amazon-ec2-instances-with-opscode-chef-using-knife)

#Third Party Accounts Required
* Set up an account with the Opscode platform and follow their
  quickstart guide. [http://www.opscode.com/chef/]()
* Amazon Web Services (AWS) Elastic Compute Cloud (EC2)

#User Guide

##run.sh

`run.sh` is the main entry point.  It takes 2 optional positional
arguments.

* COUNT = how many servers to create. Defaults to 1.
* PREFIX = Prefix to use when naming the nodes in Chef. Will be followed
  by a simple integer serial number. (Web-1, Web-2, Web-3, etc).
Defaults to "rgtest".

All servers will build and process in parallel.  However, this means the
output from the build processes are all intermingled (as of now), so
they are hard to read.  The script can be easily modified to run in
serial instead as needed (See the Troubleshooting section below).

##task.rb

`task.rb` is a little utility script not unlike a Makefile or Rakefile.  It just
automates most things you might have to type on the command line while working
in this project. Run it with `./task.rb COMMAND` where COMMAND is one of the
following.

* real_creds
    * We don't want to store real credentials for S3 in git, so I use this to
      quickly enable a different knife.rb file that has the real info
* sample_creds
    * opposite of real_creds
* upload
    * Builds the chef cookbook and uploads it to chef
    * Uploads the clouddial_conf.json file as a chef data bag
    * This command MUST be run at least once before run.sh will work
* clean
    * remove the `results` directory
* list
    * list all EC2 instances and chef nodes
* delete
   * Delete a chef node or EC2 instance by name
   * If the name passed on the command line starts with "i-", it is assumed to
     be an EC2 instance ID as opposed to a chef node name

#Troubleshooting

The server jobs can trivially be switched from parallel execution to
serial execution by commenting out the & sign from the createInstances
function in run.sh (It is clearly marked with a comment to this effect).

You may want to disable deletion of the EC2 instances and/or the chef nodes for
troubleshooting failed installed.  This can be done in run.sh

#Known Limitations
* Error handling! There is slim to none thus far.  If your JSON config
  file is imperfect in any way, stack traces are coming your way. Most failures
are not yet properly detected and handled.
* The spec asked for EC2 Micro instances. Fog doesn't support that
  (yet).  The code we'd have to fix is
[here](https://github.com/geemus/fog/blob/b1655ab847c2a822c35198c496affed30f78a71a/lib/fog/aws/models/ec2/flavors.rb)
We created `m1.small` instances instead.
* Not everything is cleanly separated out into a config file yet.
  Specifically the region "us-west-1" is still hard coded.  If you don't
specify the right region, most EC2 operations return nothing, which can
be confusing.

#Open Issues
* If you create enough instances to end up with a re-using of the same EC2 FQDN, ssh
  can complain about incorrect host key.  Delete stale entries from your
`~/.ssh/known_hosts` for EC2 FQDNs to work around this.

#Resolved Issues
* knife bootstrap process is not highly reliable.  Sometimes fails.
    * It hangs at "INFO: Bootstrapping Chef on" and my local workstation
      CPU starts to thrash
    * [Here's a
      link](http://help.opscode.com/discussions/problems/233-ec2-instances-sometimes-do-not-bootstrap-with-knife-due-to-authentication-failure)
to others having this problem
    * Applying that monkey patch to knife.rb DOES seem to have fixed the
      issue

