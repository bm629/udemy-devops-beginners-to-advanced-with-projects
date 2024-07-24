#!/bin/bash

DATABASE_PASS='admin123'

# 1. Install Dependencies
yum update -y
yum install epel-release -y
yum install git mariadb-server -y

# 2. Start MySQL Server
sudo systemctl start mariadb
sudo systemctl enable mariadb

# 3. MySQL Installation Setup
mysqladmin -u root password "$DATABASE_PASS"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# 4. Create Database
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git
mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

systemctl restart mariadb