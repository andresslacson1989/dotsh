!#/bin/bash

#################################################
#  Server Configuration for Ubuntu 16.04 LTS    #
#              Don't use port 7071              #     
#################################################

## updating system
sudo apt update -y

## installing dependencies
sudo apt install unzip software-properties-common python3-software-properties python-software-properties sed -y

## intalling HTTP Server (Powered by Apache2)
sudo apt install apache2 -y

## starting the http server
sudo service apache2 start

## fix for hostname resolving
echo "ServerName	localhost" >> /etc/apache2/apache2.conf

## restart the http service
sudo service apache2 restart

## adding the PHP Repository
sudo add-apt-repository ppa:ondrej/php -y

## update
sudo apt update

## install php
sudo apt install php7.0 php7.0-mcrypt php7.0-mysql php7.0-curl php7.0-mbstring libapache2-mod-php7.0 php7.0-common php7.0-xml -y

## change to port 7071
echo "Listen 8080" >> /etc/apache2/apache2.conf

## install phpsysinfo
cd /var/www/html
rm -R *
wget https://github.com/phpsysinfo/phpsysinfo/archive/master.zip
unzip master.zip
cp -r phpsysinfo-master/* /var/www/html
mv phpsysinfo.ini.new phpsysinfo.ini

## restart
sudo service apache2 restart 
