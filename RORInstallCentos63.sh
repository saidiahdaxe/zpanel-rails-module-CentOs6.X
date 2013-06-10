#!/bin/bash

#######################################################################
# RubyOnRails Module for ZPanelX Automated Installer for CentOs-6.X   #
# Created by: SAIDI Ahd (ahd.saidi@axelaris.com)                   	  #
#######################################################################


clear

echo -n "################################################################\n"
echo -n "# RubyOnRails Module for ZPanelX Installer                     #\n"
echo -n "# Created by: SAIDI Ahd (ahd.saidi@axelaris.com)               #\n"
echo -n "################################################################\n"


if [ "$(id -u)" != "0" ]; then
   echo "Sorry, this script must be run as root!" 1>&2
   exit 1
fi

# Install of required Tools ...

yum update -y 
yum groupinstall "Development Tools" -y
yum install wget sqlite curl-devel openssl-devel httpd-devel apr-devel apr-util-devel libzlib-ruby zlib-devel -y 

#############################################################
#Installing libyaml											#
#############################################################
cd /root/
wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
tar xzvf yaml-0.1.4.tar.gz
cd yaml-0.1.4
./configure --prefix=/usr/local
make
make install

#############################################################
# We now download the latest version of Ruby and build it...#
#############################################################
cd /root/
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p194.tar.gz
tar xvzf ruby-1.9.3-p194.tar.gz
cd ruby-1.9.3-p194
./configure
make
make install
#############################################################
# Print de Ruby Version									    #
#############################################################

ruby --version 
echo "is successfully installed ... \n"

####################################################################
# We now download the latest version of RubyGems and install it...#
####################################################################
cd /root/
wget http://rubyforge.org/frs/download.php/76073/rubygems-1.8.24.tgz
tar xvzf rubygems-1.8.24.tgz
cd rubygems-1.8.24
ruby setup.rb

#In case of erreur , make sure to run a  "clean compilation" process
# and reverify the depandancy tools installation

gem update --system
gem install rubygems-update
update_rubygems

#############################################################
# Print de Ruby Version									    #
#############################################################
gem --version
echo "is successfully installed ... \n"

# Lets now install some Ruby Gems...
#Install rake
#gem install rake
#rake installation cause some problem in auto installation : impose interaction
## Install rails...
gem install rails
## Install bundler...
gem install bundler
## Install passenger...
gem install passenger

##
gem list



#Run new Passenger conncection ...
#For the auto build we will use --auto
passenger-install-apache2-module --auto


# Run new Passenger connection...[A verifié: voir doc passenger]

# Now we need to do a few config changes (this will be done by the zppy package!)
#
#   LoadModule passenger_module /usr/local/lib/ruby/gems/1.9.1/gems/passenger-4.0.4/libout/apache2/mod_passenger.so
#   PassengerRoot /usr/local/lib/ruby/gems/1.9.1/gems/passenger-4.0.4
#   PassengerDefaultRuby /usr/local/bin/ruby


#Suppose you have a Rails application in /somewhere. Add a virtual host to your
#Apache configuration file and set its DocumentRoot to /somewhere/public:
#
# <VirtualHost *:80>
#      ServerName www.yourhost.com
#      # !!! Be sure to point DocumentRoot to 'public'!
#      DocumentRoot /somewhere/public
#      <Directory /somewhere/public>
#         # This relaxes Apache security settings.
#         AllowOverride all
#         # MultiViews must be turned off.
#         Options -MultiViews
#      </Directory>
#   </VirtualHost>
#
#
