#!/bin/bash

if [ -f "/etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com" ]
then
    echo "Nginx /etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com already exist. Skip override file."
else
    echo "Create /etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com file"
    sudo touch "/etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com"

    echo "Change ${JOB_BASE_NAME}.comuna18.com permissions"
    sudo chmod 777 "/etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com"

    echo "Write /etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com configuration"
    cat > "/etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com" <<- EOM
upstream ${JOB_BASE_NAME}_server{
  server unix:${WORKSPACE}/run/gunicorn.sock fail_timeout=0;
}

server {
  listen 80;
  server_name ${domain};
  error_log ${WORKSPACE}/tmp/log/nginx_error.log;
  access_log ${WORKSPACE}/tmp/log/nginx_access.log;

  location /static/ {
    autoindex on;
    alias ${WORKSPACE}/src/static/;
  }

  location /media/ {
    autoindex on;
    alias ${WORKSPACE}/src/media/;
  }

  location / {
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        # proxy_set_header X-Forwarded-Proto https;
        proxy_set_header Host \$http_host;
        proxy_redirect off;
        # proxy_buffering off;

        if (!-f \$request_filename) {
            proxy_pass http://${JOB_BASE_NAME}_server;
            break;
        }
    }
}

EOM

    echo "Change /etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com owner and permissions"
    sudo chmod 644 "/etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com"
    sudo chown root:root "/etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com"

    echo "Make symbolic link to sites-enabled"
    sudo ln -s "/etc/nginx/sites-available/${JOB_BASE_NAME}.comuna18.com" /etc/nginx/sites-enabled/

    echo "Check Nginx configuration"
    sudo nginx -t

    echo "Reload Nginx"
    sudo systemctl reload nginx
fi

echo "Nginx Restart and Status"
sudo systemctl restart nginx
sudo systemctl status nginx
