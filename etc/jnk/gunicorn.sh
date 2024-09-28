#!/bin/bash

if [ -f "bin/gunicorn_start.sh" ]
then
	echo "gunicorn_start.sh already exist. Skip override file."
else
	echo "Write gunicorn_start.sh file configuration"
	cat > "bin/gunicorn_start.sh" <<- EOM
#!/bin/bash

NAME="${JOB_BASE_NAME}"                                  # Name of the application
REPODIR="${WORKSPACE}"
NUM_WORKERS=${workers};                                     # how many worker processes should Gunicorn spawn

DJANGODIR="\$REPODIR/src"        # Django project directory
SOCKFILE="\$REPODIR/run/gunicorn.sock"  # we will communicte using this unix socket
USER=jenkins	# the user to run as
GROUP=jenkins                                  # the group to run as
DJANGO_SETTINGS_MODULE=app.settings
DJANGO_WSGI_MODULE=app.wsgi                     # WSGI module name

echo "Starting \$NAME as \`whoami\`"

# Activate the virtual environment
cd \$DJANGODIR
source ../tmp/venv/bin/activate
export DJANGO_SETTINGS_MODULE=\$DJANGO_SETTINGS_MODULE
export PYTHONPATH=\$DJANGODIR:\$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=\$(dirname \$SOCKFILE)
test -d \$RUNDIR || mkdir -p \$RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec ../tmp/venv/bin/gunicorn \${DJANGO_WSGI_MODULE}:application \
  --name \$NAME \
  --workers \$NUM_WORKERS \
  --user=\$USER --group=\$GROUP \
  --bind=unix:\$SOCKFILE \
  --log-level=debug \
  --log-file=-
EOM
fi
