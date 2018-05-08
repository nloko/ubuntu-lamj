#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PASSWORD='12345678'
PROJECTFOLDER='myproject'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install tomcat 
sudo apt-get -y install tomcat7

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup users file
VHOST=$(cat <<EOF
<tomcat-users>
    <user username="admin" password="password" roles="manager-gui,admin-gui"/>
</tomcat-users>
EOF
)
echo "${VHOST}" > /etc/tomcat7/tomcat-users.xml 

# restart apache
sudo service tomcat7 restart

# extras
sudo apt-get -y install tomcat7-docs tomcat7-admin tomcat7-examples

# install java
sudo apt-get -y install default-jdk

# install git
sudo apt-get -y install git

# install ant 
sudo apt-get -y install ant
