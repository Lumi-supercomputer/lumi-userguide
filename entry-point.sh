#!/bin/bash

#if [ ! -f /etc/htpasswd/htpasswd ];
#then
#    echo "No '/etc/htpasswd/htpasswd' found, using default (user: 'admin', password: 'adminp')"
#   mkdir /etc/htpasswd/
#    htpasswd -cb /etc/htpasswd/htpasswd admin adminp
#else
#    echo "Found '/etc/htpasswd/htpasswd', using it."
#fi

echo "Launching nginx"

exec /usr/sbin/nginx
