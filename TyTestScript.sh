#!/bin/bash

# Get the script files:
# fresh_check.sh
# host_info_t1.sh

# unzip them to the same directory

# copy files over to s01 using scp
# scp ~/Downloads/*.{sh,rpm} root@s01:/tmp

# connect to s01 on w01
# ssh root@s01

# Cd to /tmp
# cd /tmp

# run the following command
# sed -i -e 's/\r$//' TyTestScript.sh

# run TyTestScript.sh
# ./TyTestScript.sh

chmod +rwx ./fresh_check.sh
chmod +rwx ./host_info_t1.sh
chmod +rwx ./wget-1.19.5-10.el8.x86_64.rpm

./fresh_check.sh

useradd andy
useradd amita

# Set the password for both new users to mohawk1
# passwd andy mohawk1
# passwd amita

# Force each user to change their password the next time they log on.
# passwd -e andy
# passwd -e amita

groupadd web
usermod -aG web andy
usermod -aG web amita

pvcreate /dev/sdb /dev/sdc
vgcreate vgWeb /dev/sdb /dev/sdc
lvcreate -l 100%FREE -n lvol0 vgWeb

mkfs -t ext4 /dev/vgWeb/lvol0

mkdir /mnt/web
mount /dev/vgWeb/lvol0 /mnt/web

# Add the following line to /etc/fstab:
# vi /etc/fstab
# /dev/vgWeb/lvol0 /mnt/web ext4 defaults 0 2
# esc
# :wq

chown root:web /mnt/web
chmod 2770 /mnt/web

yum install /tmp/wget-1.19.5-10.el8.x86_64.rpm -y
yum install httpd -y

systemctl enable httpd
systemctl start httpd

# Add message Amita and Andy to default web page
# vi /var/www/html/index.html
# Amita and Andy
# esc
# :wq

# Add the following lines to /etc/cron.d/web
# vi /etc/cron.d/web
# 30 23 * * * root systemctl stop httpd
# 0 7 * * * root systemctl start httpd
# esc
# :wq

# Run host_info_t1.sh last

# Exit s01
# exit

# scp s01_report_services.html to w01
# scp root@s01:/tmp/s01_report_services.html /tmp

# check in firefox or upload it
