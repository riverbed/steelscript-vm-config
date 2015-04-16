This directory includes openssl-generated self-signed certs.  The nopass file
has been filtered to remove the required passphrase so restarts can be done
without human intervention.

Steps to reproduce:

$ sudo /usr/bin/openssl req -new -x509 -days 365 -out /etc/ssl/localcerts/apache_local.pem -keyout /etc/ssl/localcerts/apache_local.key
$ sudo openssl rsa -in apache_local.key -out apache_local_nopass.key


