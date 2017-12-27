!#/bin/sh

#################################################
#     Server Configuration for Debian Final     #
#              Don't use port 7071              #     
#################################################

## updating packages
sudo apt-get update -y

## installing dependencies
sudo apt-get install unzip -y
sudo apt-get install nano -y
sudo apt-get install sed -y
sudo apt-get install screen -y

## installing HTTP Server (Powered By Apache)
sudo apt-get install apache2 -y

## starting HTTP Services
sudo service apache2 start

## fix for hostname resolving
echo "ServerName	localhost" >> /etc/apache2/apache2.conf

## install PHP5
sudo apt-get install php5 php5-mysql php-devel php5-gd php5-pecl-memcache php5-pspell php5-snmp php-xml-rpc php-xml libapache2-mod-php5 -y

## change to port 7071
echo "Listen	8080" >> /etc/apache2/apache2.conf

##restarting HTTP Services
sudo service apache2 restart

## downloading phpsysinfo
cd /var/www/html
rm -R *
wget https://github.com/phpsysinfo/phpsysinfo/archive/master.zip
unzip master.zip
cp -r phpsysinfo-master/* /var/www
mv phpsysinfo.ini.new phpsysinfo.ini

## finishing installation
sudo service apache2 restart
