# 1. Install Dependencies
apt update -y
apt upgrade -y

# 2. Install Nginx
apt install nginx -y

# 3. Configure Nginx
cat > /etc/nginx/sites-available/vproapp <<EOF
upstream vproapp {
    server app01:8080;
}

server {
    listen 80;
    
    location / {
        proxy_pass http://vproapp;
    }
}
EOF

rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
systemctl restart nginx
systemctl enable nginx