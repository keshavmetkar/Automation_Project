#!/bin/bash
apt update -y #update the package details

#checks whether the HTTP Apache server is already installed. If not present, then it installs the server
if [[ $(dpkg-query -l | grep apache2 | wc -l) > 0 ]]; then
        echo "apache is already Installed"
else apt install apache2 -y
        echo "apache was not installed. Installation Done"
fi

#checks whether the server is running or not.If it is not running, then it starts the server
if [[ $(service apache2 status) == *"active (running)"* ]]; then
  echo "apache process is running"
else systemctl start apache2
        echo "apache process started"
fi

# ensures that HTTP Apache service is enabled
if [[ $(systemctl status apache2 | grep "Active: active (running)" | wc -l) > 0 ]]; then
        echo "apache is already enabled"
else systemctl enable apache2
        echo "apache was not enabled. Now enablede"
fi

if [[ $(dpkg-query -l | grep awscli | wc -l) > 0 ]]; then
        echo "awscli is already Installed"
else apt install awscli -y
        echo "awscli was not installed. Installation Done"
fi

#Archiving logs to S3
cd /
mkdir tmp
cd tmp
timestamp=$(date '+%d%m%Y-%H%M%S')
name="keshav" #name variable
tar -zcvf $name-httpd-logs-$timestamp.tar /var/log/apache2/*.log
S3_name="upgrad-keshav" #S3 variable name
aws s3 cp /tmp/$name-httpd-logs-$timestamp.tar s3://$S3_name/keshav-httpd-logs-$timestamp.tar

