#!/bin/bash
cat >/etc/motd <<EOL 
  _____                               
  /  _  \ __________ _________   ____  
 /  /_\  \\___   /  |  \_  __ \_/ __ \ 
/    |    \/    /|  |  /|  | \/\  ___/ 
\____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
A P P   S E R V I C E   O N   L I N U X

Documentation: http://aka.ms/webapp-linux
PHP quickstart: https://aka.ms/php-qs

EOL
cat /etc/motd

# Get environment variables to show up in SSH session
eval $(printenv | grep -v -e '^PWD\|^OLDPWD\|^HOME\|^USER\|^TERM' | awk -F= '{print "export " $1"=\""$2"\"" }' > /etc/profile.d/dockerenv.sh)

# Start ssh
service ssh start

# Run post deployment script
if [ "$POST_DEPLOYMENT_SCRIPT" != "" ]; then
    if [ -e "$POST_DEPLOYMENT_SCRIPT" ]; then
        echo "Running POST_DEPLOYMENT_SCRIPT: $POST_DEPLOYMENT_SCRIPT ..."
        echo "(errors will be ignored to avoid failing container startup)"
        bash $POST_DEPLOYMENT_SCRIPT || true
    else
        echo "No POST_DEPLOYMENT_SCRIPT found under path: $POST_DEPLOYMENT_SCRIPT"
    fi
else
    echo "No POST_DEPLOYMENT_SCRIPT defined"
fi

# Start webserver
APACHE_DOCUMENT_ROOT_ESCAPED="$(echo "$APACHE_DOCUMENT_ROOT" | sed "s/\//\\\\\//g")"
sed -i "s/{PORT}/$PORT/g" /etc/apache2/apache2.conf
sed -i "s/{APACHE_DOCUMENT_ROOT}/$APACHE_DOCUMENT_ROOT_ESCAPED/g" /etc/apache2/apache2.conf
sed -i "s/\/var\/www\/html/$APACHE_DOCUMENT_ROOT_ESCAPED/g" /etc/apache2/sites-available/000-default.conf
mkdir -p "$APACHE_DOCUMENT_ROOT"
mkdir /var/lock/apache2
mkdir /var/run/apache2
/usr/sbin/apache2ctl -D FOREGROUND
