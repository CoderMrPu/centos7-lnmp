#!/usr/bin/env bash

block="# nginx server
# $1 information configuration
server {
    listen ${3:-80};
    server_name $1;
    root $2;

    # Load configuration files for the default server block.
    include /etc/nginx/default.d/*.conf;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
"
echo "$block" > "/etc/nginx/sites-available/$1.conf"

sudo systemctl restart nginx