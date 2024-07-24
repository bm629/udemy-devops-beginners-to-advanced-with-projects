# 1. Install Dependencies
yum update -y
yum install epel-release -y
dnf install -y java-11-openjdk java-11-openjdk-devel git maven wget

# 2. Download & Extract Tomcat
TOMCAT_URL="https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz"
cd /tmp/
wget $TOMCAT_URL
tar xzvf apache-tomcat-9.0.75.tar.gz

# 3. Configure Tomcat User & Server
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
chown -R tomcat.tomcat /usr/local/tomcat

rm -rf /etc/systemd/system/tomcat.service

cat > /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Tomcat
After=network.target

[Service]

User=tomcat
Group=tomcat

WorkingDirectory=/usr/local/tomcat

#Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre

Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat

ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh


RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

systemctl start tomcat
systemctl enable tomcat

# 4. Deploy Application
cd /tmp
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
mvn install
systemctl stop tomcat
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
chown tomcat.tomcat /usr/local/tomcat/webapps -R
systemctl start tomcat