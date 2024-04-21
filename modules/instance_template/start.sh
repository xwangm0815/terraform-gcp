#! /bin/bash

sudo yum update -y
sudo cat <<EOF >> /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=https://nginx.org/packages/rhel/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF
sudo yum install nginx -y
sudo sed -i -e "s|Welcome|VM $HOSTNAME|g" /usr/share/nginx/html/index.html
sudo systemctl start nginx
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload

