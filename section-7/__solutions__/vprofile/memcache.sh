# 1. Install Dependencies
yum update -y
yum install epel-release -y

# 2. Install Memcached
dnf install memcached -y
systemctl start memcached
systemctl enable memcached

# 3. Memcached Configuration
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
systemctl restart memcached
