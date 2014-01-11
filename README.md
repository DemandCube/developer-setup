smorin-devsetup
========

Sets up a mac for development with virtualbox vagrant ansible and pip

bootstrap.sh
----
This installs pip and ansible

setup.sh
----
This installs vagrant and virtualbox



Preferred Development Tools
=====
- [Ansible] (http://www.ansibleworks.com/)
- [Vangrant] (http://www.vagrantup.com/)
- [Virtualbox] (https://www.virtualbox.org/)
- [Gradle] (http://www.gradle.org/)


# Research and Notes
- [Install dmg on Mac with commandline] (http://commandlinemac.blogspot.com/2008/12/installing-dmg-application-from-command.html)
- [Test if an app is install on Mac] (http://stackoverflow.com/questions/6682335/how-can-check-if-particular-application-software-is-installed-in-mac-os)
- [Ansible and Vagrant] (http://julien.ponge.org/blog/scalable-and-understandable-provisioning-with-ansible-and-vagrant/)
- [Test if xcode] (http://railsapps.github.io/xcode-command-line-tools.html)
- [Ansible Playbooks - including Virtualbox and Vagrant] (https://github.com/MWGriffin/ansible-playbooks)


Ansible
----
- [Accelerated Mode] (http://www.ansibleworks.com/docs/playbooks_acceleration.html)
- [Provisioning Ansible] (http://docs.vagrantup.com/v2/provisioning/ansible.html)
- [Modules] (http://www.ansibleworks.com/docs/modules.html)

Video's - Tutorials
----
- [Vagrant Video] (http://www.youtube.com/watch?v=Im4wNqlolqQ)
- [Vagrant with Ansible] (http://www.youtube.com/watch?v=BTAgQ9-LD5o) 

SSH
----
Add these setting to a minimal CentOS for Virtualbox
```
echo "PermitRootLogin without-password" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
```

Nginx
----
```
###############
# Install nginx
###############

export NGINX_REPO_FILE=/etc/yum.repos.d/nginx.repo
touch $NGINX_REPO_FILE
chmod 644 $NGINX_REPO_FILE
chown root:root $NGINX_REPO_FILE


echo "[nginx]" > $NGINX_REPO_FILE
echo "name=nginx repo" >> $NGINX_REPO_FILE
echo 'baseurl=http://nginx.org/packages/centos/$releasever/$basearch/' >> $NGINX_REPO_FILE
echo "gpgcheck=0" >> $NGINX_REPO_FILE
echo "enabled=1" >> $NGINX_REPO_FILE

# Verify it worked
cat $NGINX_REPO_FILE
yum repolist

#install nginx 
yum -y install nginx.x86_64
```

selinux 
----
```
sestatus
setenforce 0 #to disable
setenforce 1 #to enable

# /etc/sysconfig/selinux 
#change from
#SELINUX=enforcing 
SELINUX=disabled
# Fix selinux context
# http://blog.rem.co/blog/2013/02/19/selinux-allowing-ssh-public-key-authentication/
# Check: /var/log/audit/audit.log
# command to fix context: restorecon -R -v /root/.ssh


# If issues investigate in
# /var/log/messages
#/var/log/secure
chown root:root /root/.ssh/
chmod 700 /root/.ssh/
ssh-keygen
cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
chown root:root /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys


```

virtualbox
----
- Machine Setup with SSH and local networking <http://webees.me/installing-centos-6-4-in-virtualbox-and-setting-up-host-only-networking/>
