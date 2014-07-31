#!/bin/bash

# http://askubuntu.com/questions/8560/how-do-i-find-out-which-repository-a-package-comes-from
# madison hint
# http://superuser.com/questions/106794/how-to-tell-from-what-ubuntu-or-debian-repository-a-package-comes/236605#236605

INSTALLED=$(dpkg --get-selections | grep -v deinstall | cut -f1)

TMPFILE=/tmp/pkglists.txt

for PKG in $INSTALLED; do
    echo "== " $PKG
    V=$(dpkg -s $PKG | grep "^Version:" | cut -d" " -f2)
    #SOURCE=$(apt-cache showpkg $PKG | grep "/var/lib" | grep $V)
    #SOURCE=$(apt-cache madison $PKG | grep $V)
    apt-cache madison $PKG | grep $V >> $TMPFILE
    #echo $SOURCE
done

mv $TMPFILE /vagrant/packages/pkglists/pkgs_all_versions.txt



