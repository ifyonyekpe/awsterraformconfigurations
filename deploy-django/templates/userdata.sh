#!/bin/bash
sudo yum update -y
sudo yum install nginx python-devel mariadb105-devel gcc git -y
sudo systemctl enable nginx
sudo systemctl start nginx

cd /home/ec2-user
git clone https://github.com/muckrack-trial-projects/django-sample-app.git
cd django-sample-app

sed -i 's/backports.zoneinfo==0.2.1/backports.zoneinfo;python_version<"3.9"/' requirements.txt
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install --upgrade pip
pip install -r requirements.txt
export DATABASE_URL=${database_url}
python manage.py migrate
pip install gunicorn
export FIRST='ALLOWED_HOSTS\s=\s\[\]'
export SECOND='ALLOWED_HOSTS = \["*"\]'
sudo sed -i "s/$FIRST/$SECOND/" mrsample/settings.py
gunicorn --workers 3 --bind=0.0.0.0:8000 -m 007 mrsample.wsgi:application --user=ec2-user --daemon
