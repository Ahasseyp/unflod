#!/bin/bash

chmod +x "${WORKSPACE}/bin/gunicorn_start.sh"

if [ -f "/etc/supervisor/conf.d/${JOB_BASE_NAME}.conf" ]
then
    echo "Supervisor conf already exist. Skip override file."
else
	echo "Create /etc/supervisor/conf.d/${JOB_BASE_NAME}.conf file"
    sudo touch "/etc/supervisor/conf.d/${JOB_BASE_NAME}.conf"

    echo "Change supervisor.conf permissions"
    sudo chmod 777 "/etc/supervisor/conf.d/${JOB_BASE_NAME}.conf"

    echo "Write /etc/supervisor/conf.d/${JOB_BASE_NAME}.conf configuration"
    cat > "/etc/supervisor/conf.d/${JOB_BASE_NAME}.conf" <<- EOM
[program:${JOB_BASE_NAME}]
command = ${WORKSPACE}/bin/gunicorn_start.sh       ; Command to start app
user = jenkins ; User to run as
stdout_logfile = ${WORKSPACE}/tmp/log/gunicorn_supervisor.log   ; Where to write log messages
redirect_stderr = true                                                ; Save stderr in the same log
logfile_maxbytes = 64MB
logfile_backups = 8
environment=LANG=en_US.UTF-8,LC_ALL=en_US.UTF-8                       ; Set UTF-8 as default encoding
EOM

    echo "Change supervisor.conf owner and permissions"
    sudo chmod 644 "/etc/supervisor/conf.d/${JOB_BASE_NAME}.conf"
    sudo chown root:root "/etc/supervisor/conf.d/${JOB_BASE_NAME}.conf"

    echo "Supervisor update"
    sudo supervisorctl reread
    sudo supervisorctl update
fi

echo "Restart supervisorctl Daemon"
sudo supervisorctl restart "${JOB_BASE_NAME}"
