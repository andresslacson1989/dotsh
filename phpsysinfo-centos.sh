!#/bin/sh

#################################################
#  Server Configuration for Centos 6.8 Final    #
#              Don't use port 7071              #     
#################################################

## updating packages
sudo yum update -y

## installing dependencies
sudo yum install unzip -y
sudo yum install nano -y
sudo yum install sed -y
sudo yum install screen -y

## installing HTTP Server (Powered By Apache)
sudo yum install httpd mod_ssl -y

## starting HTTP Services
sudo /usr/sbin/apachectl start

## fix for hostname resolving
echo "ServerName	localhost" >> /etc/httpd/conf/httpd.conf

## make automatic start after reboot
sudo /sbin/chkconfig httpd on

## make sure automatic start is running
sudo /sbin/chkconfig --list httpd | grep httpd

## install PHP
sudo yum install php php-mysql php-devel php-gd php-pecl-memcache php-pspell php-snmp php-xmlrpc php-xml -y

## change to port 7071
sed -i -e 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf

##restarting HTTP Services
sudo /usr/sbin/apachectl restart

## downloading phpsysinfo
cd /var/www/html
rm -rf *
wget https://github.com/phpsysinfo/phpsysinfo/archive/master.zip
unzip master.zip
cp -r phpsysinfo-master/* /var/www/html
mv phpsysinfo.ini.new phpsysinfo.ini

mkdir -p /var/www/html/html
cd /var/www/html/html
rm -rf *
wget https://github.com/phpsysinfo/phpsysinfo/archive/master.zip
unzip master.zip
cp -r phpsysinfo-master/* /var/www/html/html
mv phpsysinfo.ini.new phpsysinfo.ini

## finishing installation
sudo /usr/sbin/apachectl restart
