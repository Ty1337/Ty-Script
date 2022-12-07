cd ~/Downloads

# Download fresh_check.sh and host_info_t2.sh from MyCanvas

# Chmod the scripts to make them executable
chmod +x ./fresh_check.sh ./host_info_t2.sh

# Scp the scripts to s01
scp ~/Downloads/*.sh root@s01:/tmp/

########################################################################################
# Excute these commands on s01
cd /tmp

./fresh_check.sh

tar -C / -cf etc.tar etc

groupadd w01users
useradd alice

yum install nfs-utils -y -q

firewall-cmd --permanent --add-service=nfs3
firewall-cmd --reload

mkdir -p /nfs/w01

chown alice:w01users /nfs/w01
chmod 2777 /nfs/w01

getent passwd alice
getent group w01users

# vi /etc/exports and add the following line
/nfs/w01 w01(rw,all_squash,anonuid=1000,anongid=1000)
# exit vi with :wq

systemctl enable --now nfs-server

########################################################################################
# Excute these commands on w01

mkdir -p /nfs/w01

# vi /etc/fstab and add the following line
s01:/nfs/w01 /nfs/w01 nfs defaults 0 2
# exit vi with :wq

mount -t nfs s01:/nfs/w01 /nfs/w01

echo "test" >/nfs/w01/test.txt

yum install httpd -y -q

# vi /etc/httpd/conf/httpd.conf and change the following line
ErrorLog "logs/error_log" to ErrorLog syslog:local2
# exit vi with :wq

systemctl start httpd

########################################################################################
# Excute these commands on s01

yum install net-tools -y -q

firewall-cmd --permanent --add-port=514/tcp
firewall-cmd --reload

# vi /etc/rsyslog.conf and uncomment the following lines
#module(load="imtcp")/module(load="imtcp")
#input(type="imtcp" port="514")

# vi /etc/rsyslog.conf and add the following line
local2.* /var/log/httpd.err
# exit vi with :wq

systemctl restart rsyslog

########################################################################################
# Excute these commands on w01

# vi /etc/rsyslog.conf and add the following line
local2.* @@s01

systemctl restart rsyslog

curl http://localhost

logger -p local2.info "info test"
logger -p local2.warning "warning test"
logger -p local2.err "error test"

########################################################################################
# Excute these commands on s01

cd /tmp

# Create an Incremental Backup
tar -C / -cf ./changes.tar --newer-mtime='1 day ago' etc

./host_info_t2.sh

########################################################################################
# Excute these commands on w01

scp root@s01:/tmp/s01_report_t2.html /tmp
