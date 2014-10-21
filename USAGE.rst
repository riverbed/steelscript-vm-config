SteelScript VM Configuration and Usage
======================================

Command-line Python Development Environment with SteelScript


Introduction
------------

This document describes the layout and configuration of the SteelScript VM
along with important security considerations should you deploy this VM
within your network.


SteelScript Application Framework
---------------------------------

1. On your host machine, head to the URL
   `https://127.0.0.1:30443 <https://127.0.0.1:30443>`_ and after accepting
   the self-signed certificate the portal should appear!
2. You will see a page with form fields for a profiler and shark appliance,
   fill out the IP address/port and Username/Password for each appliance
3. Click the "Reports" button on the navigation bar, and run a report!

To customize the reports that are available and take a peek under the hood, you
can ssh directly into the VM and look at each of the report files:

.. code-block:: console

        $ vagrant ssh
        vagrant@precise32:~$ cd /steelscript/steepscript_appfwk/config/reports

Changes and edits can now easily be made in the staging area without the need for
sudo'ing or worrying about permissions.

A summary of included aliases and commands:

========================= ==========================================================================
Aliases / Functions       Description
========================= ==========================================================================
``view_err_log``          show the apache error log
``view_access_log``       show the apache access log
``view_portal_log``       show the portal debug log

``cdproject``             shortcut to `cd /home/vagrant/steelscript_appfwk`, the staging directory
``cdwww``                 shortcut to `cd /steelscript/www`, the deployed directory
``cdshared``              shortcut to `cd /vagrant`, the shared directory with the host machine.
                          This can be a convenient way to share files between the guest and host.

``run_ipython_notebooks`` shortcut to run ipython notebook server (documented below)
``appfwk_dev_server``     shortcut to run the django development server in the staging directory
``appfwk_collect_logs``   collects and zips up all the appropriate logs to help with
                          debugging VM or App Framework issues.

``virtualenv_dev``        activate steelscript python virtualenv (automatically at login)
========================= ==========================================================================

For further information, see the following descriptions about App Framework and how to
customize it:

    `SteelScript App Framework on GitHub <https://github.com/riverbed/steelscript-app-fmwk>`_


Security Considerations
-----------------------

This Virtual Machine should be considered a demonstration platform and not a
hardened and secure VM without additional configuration.  Areas which should be
considered to improve security:

   - Core OS
      - Change root password from 'vagrant'
      - Change vagrant user password from 'vagrant'
      - Remove and/or replace 'vagrant insecure public key' from
        vagrant/.ssh/authorized_keys
      - Update sudoers config (vagrant has passwordless sudo)
   - Apache Server
      - Replace self-signed SSL certs
          - located in /etc/ssl/localcerts/*
      - Change root mysql password from 'vagrantRoot!'
      - Change django database 'django_appfwk_db' password from
        'djangoSteelScript!'

Replacing SSL Certs
+++++++++++++++++++

As noted above, the apache server is configured to use HTTPS connections
primarily to demonstrate the confugration approach.  The following certs are
installed and should be replaced:

    SSLCertificateFile      /etc/ssl/localcerts/apache_local.pem
    SSLCertificateKeyFile   /etc/ssl/localcerts/apache_local.key

Instructions on creating a new self-signed cert can be found at the following
link.  Only Step 2 will be required as the other steps have already taken
place:

    https://wiki.debian.org/Self-Signed_Certificate

Note that if you create a cert it will require a passcode on every reboot and
may require manually restarting Apache each time. If you'd prefer to remove
that requirement the following command will create a clone of the key with the
passcode removed:

    $ sudo openssl rsa -in apache_local.key -out apache_local_nopass.key


IPython Notebooks
-----------------

IPython is a python shell replacement that adds a lot of helpful features
and shortcuts to make working with python much easier.  The Notebooks feature
builds on top of that to add a web-based component allowing for a playground
of sorts with the ability to re-run bits of python code easily while building
up to more complicated functions.

This Notebook configuration has been installed in the VM as well, and you can
get started with it using a few short steps:

1. Login to the machine, and start a fresh IPython notebook instance:

.. code-block:: console

        $ vagrant ssh
        vagrant@precise32:~$ run_ipython_notebook
        [NotebookApp] Created profile dir: u'/home/vagrant/.ipython/profile_default'
        [NotebookApp] Serving notebooks from /home/vagrant
        [NotebookApp] The IPython Notebook is running at: http://<ipaddress>:8888/
        [NotebookApp] Use Control-C to stop this server and shut down all kernels.
        [NotebookApp] No web browser found: could not locate runnable browser.

2. On a browser on the host machine, head to the following url:
   `http://127.0.0.1:38888 <http://127.0.0.1:38888>`_.
3. A notebook instance should be visible.
4. Any notebooks created, will be saved to the directory where the command was
   started from.  In the example above, this would be the home directory for
   the user ``vagrant`` (the default user for new virtual machines).
5. For a more in depth introduction to IPython notebooks, there are several
   examples included in the documentation:

.. code-block:: console

        vagrant@precise32:~$ cd /usr/local/share/doc/ipython/examples/notebooks
        vagrant@precise32:/usr/local/share/doc/ipython/examples/notebooks$ ipython notebook --ip=`facter ipaddress`
        [NotebookApp] Using existing profile dir: u'/home/vagrant/.ipython/profile_default'
        [NotebookApp] Serving notebooks from /usr/local/share/doc/ipython/examples/notebooks
        [NotebookApp] The IPython Notebook is running at: http://10.0.2.15:8888/
        [NotebookApp] Use Control-C to stop this server and shut down all kernels.
        [NotebookApp] No web browser found: could not locate runnable browser.

6. Now opening the same URL as in step 2 will show several pre-generated
   example scripts you can walk through. You won't be able to save changes
   here, but that should make experimentation a little easier too.

Note: this notebook will be accessible to anyone on your LAN, if additional
security is required, learn more about adding passwords and encryption
`here in the documentation <http://ipython.org/ipython-doc/dev/interactive/htmlnotebook.html#security>`_.


Virtual Machine Source Code
===========================

This Virtual Machine was built using an Ubuntu 12.04 Precise base image,
with additional Ubuntu packages installed from the Ubuntu repository.
On top of this image, python packages and additional configuration was made.

A complete archive of the source code is available at the support site at
the following location:

    https://TODO_ADD_ME

A list of the installed packages is below, broken into categories of
initial base image packages, added packages from Ubuntu, and python packages
installed from pypi.python.org:

Base Image Packages
-------------------
accountsservice, adduser, apparmor, apt, apt-transport-https, apt-utils,
apt-xapian-index, aptitude, at, base-files, base-passwd, bash, bash-completion,
bind9-host, binutils, bsdmainutils, bsdutils, busybox-initramfs,
busybox-static, bzip2, ca-certificates, command-not-found,
command-not-found-data, console-setup, coreutils, cpio, cpp, cpp-4.6, crda,
cron, dash, dbus, debconf, debconf-i18n, debianutils, diffutils, dmidecode,
dmsetup, dnsutils, dosfstools, dpkg, dpkg-dev, e2fslibs, e2fsprogs, ed, eject,
fakeroot, file, findutils, friendly-recovery, ftp, fuse, gcc, gcc-4.6,
gcc-4.6-base, geoip-database, gettext-base, gir1.2-glib-2.0, git, gnupg, gpgv,
grep, groff-base, grub-common, grub-gfxpayload-lists, grub-pc, grub-pc-bin,
grub2-common, gzip, hdparm, hostname, ifupdown, info, initramfs-tools,
initramfs-tools-bin, initscripts, insserv, install-info, installation-report,
iproute, iptables, iputils-ping, iputils-tracepath, irqbalance,
isc-dhcp-client, isc-dhcp-common, iso-codes, kbd, keyboard-configuration,
klibc-utils, krb5-locales, language-pack-en, language-pack-en-base,
language-pack-gnome-en, language-pack-gnome-en-base, language-selector-common,
laptop-detect, less, libaccountsservice0, libacl1, libapt-inst1.4,
libapt-pkg4.12, libasn1-8-heimdal, libattr1, libbind9-80, libblkid1,
libboost-iostreams1.46.1, libbsd0, libbz2-1.0, libc-bin, libc-dev-bin, libc6,
libc6-dev, libcap-ng0, libcap2, libclass-accessor-perl, libclass-isa-perl,
libcomerr2, libcurl3, libcurl3-gnutls, libcwidget3, libdb5.1, libdbus-1-3,
libdbus-glib-1-2, libdevmapper-event1.02.1, libdevmapper1.02.1, libdns81,
libdrm-intel1, libdrm-nouveau1a, libdrm-radeon1, libdrm2, libedit2, libelf1,
libept1.4.12, libevent-2.0-5, libexpat1, libffi6, libfreetype6, libfribidi0,
libfuse2, libgcc1, libgcrypt11, libgdbm3, libgeoip1, libgirepository-1.0-1,
libglib2.0-0, libgmp10, libgnutls26, libgomp1, libgpg-error0, libgssapi-krb5-2,
libgssapi3-heimdal, libgssglue1, libhcrypto4-heimdal, libheimbase1-heimdal,
libheimntlm0-heimdal, libhx509-5-heimdal, libidn11, libio-string-perl,
libisc83, libisccc80, libisccfg82, libk5crypto3, libkeyutils1, libklibc,
libkrb5-26-heimdal, libkrb5-3, libkrb5support0, libldap-2.4-2,
liblocale-gettext-perl, liblockfile-bin, liblockfile1, liblwres80, liblzma5,
libmagic1, libmount1, libmpc2, libmpfr4, libncurses5, libncursesw5,
libnewt0.52, libnfnetlink0, libnfsidmap2, libnih-dbus1, libnih1, libnl-3-200,
libnl-genl-3-200, libopts25, libp11-kit0, libpam-modules, libpam-modules-bin,
libpam-runtime, libpam0g, libparse-debianchangelog-perl, libparted0debian1,
libpcap0.8, libpci3, libpciaccess0, libpcre3, libpipeline1, libplymouth2,
libpng12-0, libpolkit-gobject-1-0, libpopt0, libquadmath0, libreadline-dev,
libreadline6, libreadline6-dev, libroken18-heimdal, librtmp0, libsasl2-2,
libsasl2-modules, libselinux1, libsigc++-2.0-0c2a, libslang2, libsqlite3-0,
libss2, libssl-dev, libssl-doc, libssl1.0.0, libstdc++6, libsub-name-perl,
libswitch-perl, libtasn1-3, libtext-charwidth-perl, libtext-iconv-perl,
libtext-wrapi18n-perl, libtimedate-perl, libtinfo-dev, libtinfo5, libtirpc1,
libudev0, libusb-0.1-4, libusb-1.0-0, libuuid1, libwind0-heimdal, libwrap0,
libx11-6, libx11-data, libxapian22, libxau6, libxcb1, libxdmcp6, libxext6,
libxml2, libxmuu1, linux-firmware, linux-generic-pae,
linux-image-3.2.0-23-generic-pae, linux-image-generic-pae, linux-libc-dev,
locales, lockfile-progs, login, logrotate, lsb-base, lsb-release, lshw, lsof,
ltrace, lvm2, makedev, man-db, manpages, manpages-dev, mawk, memtest86+,
mime-support, mlocate, module-init-tools, mount, mountall, mtr-tiny,
multiarch-support, nano, ncurses-base, ncurses-bin, net-tools, netbase,
netcat-openbsd, nfs-common, ntfs-3g, ntp, ntpdate, openssh-client,
openssh-server, openssl, os-prober, parted, passwd, pciutils, perl, perl-base,
perl-modules, plymouth, plymouth-theme-ubuntu-text, popularity-contest,
powermgmt-base, ppp, pppconfig, pppoeconf, procps, psmisc, python, python-apt,
python-apt-common, python-chardet, python-dbus, python-dbus-dev, python-debian,
python-gdbm, python-gi, python-gnupginterface, python-minimal, python-xapian,
python2.7, python2.7-minimal, readline-common, resolvconf, rpcbind, rsync,
rsyslog, sed, sensible-utils, sgml-base, ssh-import-id, strace, sudo, sysv-rc,
sysvinit-utils, tar, tasksel, tasksel-data, tcpd, tcpdump, telnet, time,
tzdata, ubuntu-keyring, ubuntu-minimal, ubuntu-standard, ucf, udev, ufw,
update-manager-core, upstart, ureadahead, usbutils, util-linux, uuid-runtime,
vim-common, vim-tiny, watershed, wget, whiptail, wireless-regdb, xauth,
xkb-data, xml-core, xz-lzma, xz-utils, zlib1g, zlib1g-dev

Added Ubuntu Packages
---------------------

apache2.2-bin, apache2.2-common, apache2, apache2-mpm-worker, apache2-utils,
avahi-daemon, avahi-utils, blt, build-essential, curl, dpkg-dev,
emacs23-bin-common, emacs23-common, emacs23, emacsen-common, emacs, fakeroot,
fontconfig-config, fontconfig, g++-4.6, gconf2-common, gconf-service-backend,
gconf-service, g++, git-core, git, git-man, hicolor-icon-theme, ipython,
ipython-notebook, javascript-common, libalgorithm-diff-perl,
libalgorithm-diff-xs-perl, libalgorithm-merge-perl, libapache2-mod-wsgi,
libapr1, libaprutil1-dbd-sqlite3, libaprutil1, libaprutil1-ldap, libasound2,
libatk1.0-0, libatk1.0-data, libavahi-client3, libavahi-common3,
libavahi-common-data, libavahi-core7, libblas3gf, libcairo2, libcap2-bin,
libc-ares2, libcroco3, libcups2, libcurl3, libdaemon0, libdatrie1,
libdbd-mysql-perl, libdbi-perl, libdpkg-perl, liberror-perl, libexpat1-dev,
libfontconfig1, libfontenc1, libfreetype6-dev, libgconf-2-4, libgd2-noxpm,
libgdk-pixbuf2.0-0, libgdk-pixbuf2.0-common, libgfortran3, libgif4,
libgl1-mesa-dri, libgl1-mesa-glx, libglade2-0, libglapi-mesa, libgpm2,
libgtk2.0-0, libgtk2.0-bin, libgtk2.0-common, libhtml-template-perl, libice6,
libjack-jackd2-0, libjasper1, libjpeg8, libjpeg-turbo8, libjs-jquery,
libjs-jquery-ui, libjs-mathjax, libjs-underscore, liblapack3gf, liblcms1,
libllvm3.0, liblua5.1-0, libm17n-0, libmysqlclient18, libmysqlclient-dev,
libnet-daemon-perl, libnss-mdns, libotf0, libpam-cap, libpango1.0-0,
libperl5.14, libpgm-5.1-0, libpixman-1-0, libplrpc-perl, libpng12-dev,
libportaudio2, libpython2.7, librsvg2-2, libsamplerate0, libsensors4, libsm6,
libsmi2ldbl, libsnmp15, libsnmp-base, libstdc++6-4.6-dev, libterm-readkey-perl,
libthai0, libthai-data, libtiff4, libutempter0, libwireshark1,
libwireshark-data, libwiretap1, libwsutil1, libx11-xcb1, libxaw7, libxcb-glx0,
libxcb-render0, libxcb-shape0, libxcb-shm0, libxcomposite1, libxcursor1,
libxdamage1, libxfixes3, libxft2, libxi6, libxinerama1, libxmu6, libxpm4,
libxrandr2, libxrender1, libxss1, libxt6, libxtst6, libxv1, libxxf86dga1,
libxxf86vm1, libzmq1, m17n-contrib, m17n-db, make, mysql-client-5.5,
mysql-client-core-5.5, mysql-common, mysql-server-5.5, mysql-server-core-5.5,
mysql-server, patch, python2.7-dev, python-cairo, python-configobj,
python-crypto, python-dateutil, python-decorator, python-dev, python-glade2,
python-gobject-2, python-gobject, python-gtk2, python-imaging, python-keyczar,
python-matplotlib-data, python-matplotlib, python-mysqldb, python-nose,
python-numpy, python-pexpect, python-pip, python-pkg-resources, python-pyasn1,
python-pycurl, python-pyparsing, python-setuptools, python-simplegeneric,
python-support, python-tk, python-tornado, python-tz, python-zmq,
shared-mime-info, snmpd, snmp, sqlite3, squid-deb-proxy-client, ssl-cert,
tcl8.5, tig, tk8.5, tshark, ttf-dejavu-core, ttf-lyx, vim, vim-runtime,
wireshark-common, wireshark, wwwconfig-common, x11-common, x11-utils, xbitmaps,
xterm

Python Packages (with version numbers)
--------------------------------------
Django==1.5.10
Jinja2==2.7.3
MarkupSafe==0.23
MySQL-python==1.2.5
Pygments==1.6
Sphinx==1.2.3
ansi2html==1.0.7
argparse==1.2.1
backports.ssl-match-hostname==3.4.0.2
certifi==14.05.14
django-ace==1.0.1
django-admin-tools==0.5.1
django-announcements==1.2.0
django-extensions==1.3.7
django-model-utils==2.0.3
djangorestframework==2.3.13
docutils==0.12
importlib==1.0.3
ipython==2.3.0
jsonfield==0.9.20
matplotlib==1.4.1
mock==1.0.1
nose==1.3.4
numpy==1.8.2
numpydoc==0.5
pandas==0.13.1
pygeoip==0.3.1
pyparsing==2.0.3
python-dateutil==2.2
pytz==2014.7
pyzmq==14.4.0
requests==2.4.3
six==1.8.0
steelscript==0.9.4
steelscript.appfwk==0.9.5
steelscript.appfwk.business-hours==0.9.2
steelscript.netprofiler==0.9.3
steelscript.netshark==0.9.3
steelscript.wireshark==0.9.3
tornado==4.0.2
tzlocal==1.1.2
wsgiref==0.1.2
