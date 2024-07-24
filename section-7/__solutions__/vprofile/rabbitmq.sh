# 1. Install Dependencies
yum update -y
yum install epel-release wget -y

# 2. Install RabbitMQ
cd /tmp/
dnf -y install centos-release-rabbitmq-38
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
systemctl enable --now rabbitmq-server

# 3. Configure RabbitMQ
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator

systemctl restart rabbitmq-server