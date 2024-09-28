#!/bin/bash

test -d tmp || mkdir -p tmp
test -d run || mkdir -p run
test -d bin || mkdir -p bin

if [ -d "tmp/venv" ]
then
    echo "Python virtual environment exists."
else
	echo "Create virtual enviroment"
    python3 -m venv tmp/venv
fi

source tmp/venv/bin/activate

echo "Upgrade PIP"
python -m pip install --upgrade pip

echo "Install project requirements"
pip install -r etc/requirements.txt

echo "Install server requirements"
pip install -r etc/production.requirements.txt

echo "Install local/dev requirements"
pip install -r etc/local.requirements.txt

if [ -d "tmp/log" ] 
then
    echo "Log folder exists." 
else
	echo "Create Log folder"
    mkdir tmp/log
fi

touch tmp/log/nginx_error.log
touch tmp/log/nginx_access.log
touch tmp/log/gunicorn_supervisor.log

sudo chmod -R 777 tmp/log


if [ -f "src/app/env.py" ]
then
	echo "env.py file exists. Skip overwrite."
else
	echo "Copy env_example to env.py"
	cp etc/env_example.py src/app/env.py
fi

if [ -f "src/app/.env" ]
then
	echo ".env file exists. Skip overwrite."
else
	echo "Copy env_example to .env in settings dir"
	cp etc/env_example src/app/.env
fi

# apply migrations and collect statics

echo "Apply migrations"
python src/manage.py migrate

echo "Collect statics"
python src/manage.py collectstatic --noinput
