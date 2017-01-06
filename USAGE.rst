SteelScript VM Configuration and Usage
======================================

Command-line Python Development Environment with SteelScript


Introduction
------------

This document describes the layout and configuration of the SteelScript VM
along with important security considerations should you deploy this VM
within your network.


SteelScript Virtualenv
----------------------

A virtualenv has been created with SteelScript and all of its dependencies
already installed in the folder ``/home/vagrant/virtualenv``.  When logging in
as the default 'vagrant' user, this virtualenv will be automatically activated,
and can always be reactivated by using the included alias ``virtualenv_dev``.


VM Basics
---------

Since this VM gets built using the Vagrant framework, the default user
when logging in and performing most maintenance is the ``vagrant`` user.  This
user has sudo priveledges, and most of the non-root configuration has been
done as this user.  If you choose to use a different user for operations,
be sure to source the ``.vm_env.sh`` file inside vagrant's home directory
(/home/vagrant/.vm_env.sh) in order to get helpful aliases and config.


SteelScript Application Framework
---------------------------------

Two separate App Framework projects are included with this VM: one using the
Apache webserver, mysql backend database and started at boot time, and another
for more development-oriented use.

The projects can be found in the following locations:

===================== =====================================
Project               Directory location
===================== =====================================
Apache project        ``/steelscript/www``
Development project   ``/home/vagrant/appfwk_project``
===================== =====================================


Apache App Framework Project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To access the running Apache App Framework project, use these steps:

1. On your host machine, visit the URL
   `https://127.0.0.1:30080 <https://127.0.0.1:30080>`_, and
   you should see the login screen.
2. Enter the default credentials of `admin` / `admin` to login.
3. Next, you will see the "Edit Devices" page.  Here you can add the
   credentials for one or more Riverbed devices by filling out the IP
   address/port and authentication credentials for each appliance you wish
   to run reports against.
4. Choose a report from the "Reports" drop down list, and run a report!

When connected to the machine via ssh, you can navigate to the project folder,
with the built-in alias of ``cdwww``.  All the files should be readable by the
``vagrant`` user, but note they are all owned by the Apache user ``apache``.
Take care to ensure all files remain owned by that user should any edits take
place.  To help cleanup permissions, the bash function
``appfwk_clean_permissions`` will come in handy.

For simple edits to reports, it's even easier to use the web-based editor found
under the blue drop-down menu called "Edit Report". Once you make changes, be
sure to click ``Save File`` to save the report, then click ``Reload Report`` or
even choose ``Reload All Reports`` from the blue drop-down menu. Only then will
the changes be reflected when visiting that report.

If any edits to the project or python packages have been made, you may need to
restart the server and its associated services for them to take effect,
use the following command: ``appfwk_restart_services``, this is acually a
shortcut for the following operations:

.. code-block:: console

        $ sudo service progressd restart
        $ sudo service celeryd restart
        $ sudo service httpd restart

In the event that web clients can not access Internet, you should check out
:ref:`offline mode` for steps on how to configure the App Framework server for
offline access.

Development App Framework Project
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The development pre-configured project is located in the user's home directory,
and can be started using a few shortcuts.

App Framework has dependencies on other services which need to be running.
Each of these services has a shortcut which will start the process and print
diagnostic information to the console.  Since all of these need to be running
at the same time, the best approach is to ssh in multiple times and start each
service in a separate instance.  The following table describes the services and
how they can be started:

===================== ==================== =====================================
Service               Alias/Shortcut       Description
===================== ==================== =====================================
Progressd             ``start_progressd``  Local service for storing status and progress
Celery                ``start_celery``     Distributied job execution
Redis                 Not Applicable       Database for Celery queues (runs as service already)
App Framework Server  ``start_appfwk``     Development server
===================== ==================== =====================================

A key benefit of this project is the less strict permissions on the files.  It
can be much easier to edit some of the configurations and reports in this
project, test it out with the dev server, and iterate that pattern than trying
the same thing with the Apache project which requires careful use of ``sudo``
and permission updates.

Once certain changes have been validated in the dev server, it's a simple matter
to make the same changes to the Apache project in one go.


Aliases and Shortcuts
---------------------

A summary of included aliases and commands:

============================ ==========================================================================
Aliases / Functions          Description
============================ ==========================================================================
``view_err_log``             show the apache error log
``view_access_log``          show the apache access log
``view_appfwk_log``          show the apache server log

``appfwk_restart_services``  shortcut to restarting the apache services and dependencies
``appfwk_clean_permissions`` shortcut to cleaning up permissions in /steelscript/www directory

``cdproject``                shortcut to `cd /home/vagrant/steelscript_appfwk`, the development project directory
``cdwww``                    shortcut to `cd /steelscript/www`, the apache project directory
``cdshared``                 shortcut to `cd /vagrant`, the shared directory with the host machine.
                             This can be a convenient way to share files between the guest and host.

``run_ipython_notebook``     shortcut to run ipython notebook server (documented below)

``virtualenv_dev``           activate steelscript python virtualenv (automatically at login)
============================ ==========================================================================

For further information, see the following descriptions about App Framework and how to
customize it:

    `SteelScript App Framework Documentation <https://support.riverbed.com/apis/steelscript/appfwk/overview.html>`_


Security Considerations
-----------------------

This Virtual Machine should be considered a demonstration platform and not a
hardened and secure VM without additional configuration.  Areas which should be
considered to improve security are:

   - Core OS
      - Change root password from 'vagrant'
      - Change vagrant user password from 'vagrant'
      - Remove and/or replace 'vagrant insecure public key' from
        vagrant/.ssh/authorized_keys
      - Update sudoers config (vagrant has passwordless sudo)
   - Apache Server
      - Serve pages via HTTPS
      - Replace self-signed SSL certs
      - Enable host header verification via ALLOWED_HOSTS in /steelscript/www/local_settings.py
      - Change root mysql password from 'vagrantRoot!'
      - Change django database 'django_appfwk_db' password from
        'djangoSteelScript!'


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

Note: this notebook will be accessible to anyone on your LAN. If additional
security is required, learn more about adding passwords and encryption
`here in the documentation <http://ipython.org/ipython-doc/dev/interactive/htmlnotebook.html#security>`_.


Virtual Machine Source Code
===========================

This Virtual Machine was built using an CentOS 7.0.1406 base image,
with additional CentOS packages installed from the CentOS repository.
On top of this image, python packages and additional configuration was made.

A complete archive of the source code is available at the support site,
and the latest version can be found at the following location:

    https://splash.riverbed.com/docs/DOC-4860

A list of the installed packages is below, broken into categories of
initial base image packages, added packages from CentOS, and python packages
installed from pypi.python.org:

Base Image Packages
-------------------
acl.x86_64, aic94xx-firmware.noarch, alsa-firmware.noarch, alsa-lib.x86_64,
alsa-tools-firmware.x86_64, audit-libs.x86_64, audit.x86_64, authconfig.x86_64,
avahi-autoipd.x86_64, avahi-libs.x86_64, avahi.x86_64, basesystem.noarch,
bash.x86_64, bind-libs-lite.x86_64, bind-license.noarch, binutils.x86_64,
biosdevname.x86_64, btrfs-progs.x86_64, bzip2-libs.x86_64, bzip2.x86_64,
ca-certificates.noarch, centos-logos.noarch, centos-release.x86_64,
chkconfig.x86_64, coreutils.x86_64, cpio.x86_64, cpp.x86_64,
cracklib-dicts.x86_64, cracklib.x86_64, cronie-anacron.x86_64, cronie.x86_64,
crontabs.noarch, cryptsetup-libs.x86_64, curl.x86_64, cyrus-sasl-lib.x86_64,
dbus-glib.x86_64, dbus-libs.x86_64, dbus-python.x86_64, dbus.x86_64,
device-mapper-event-libs.x86_64, device-mapper-event.x86_64,
device-mapper-libs.x86_64, device-mapper-persistent-data.x86_64,
device-mapper.x86_64, dhclient.x86_64, dhcp-common.x86_64, dhcp-libs.x86_64,
diffutils.x86_64, dmidecode.x86_64, dnsmasq.x86_64,
dracut-config-rescue.x86_64, dracut-network.x86_64, dracut.x86_64,
e2fsprogs-libs.x86_64, e2fsprogs.x86_64, ebtables.x86_64,
elfutils-libelf.x86_64, elfutils-libs.x86_64, ethtool.x86_64, expat.x86_64,
file-libs.x86_64, file.x86_64, filesystem.x86_64, findutils.x86_64,
fipscheck-lib.x86_64, fipscheck.x86_64, firewalld.noarch, freetype.x86_64,
fxload.x86_64, gawk.x86_64, gcc.x86_64, gdbm.x86_64, gettext-libs.x86_64,
gettext.x86_64, glib-networking.x86_64, glib2.x86_64, glibc-common.x86_64,
glibc-devel.x86_64, glibc-headers.x86_64, glibc.x86_64, gmp.x86_64,
gnupg2.x86_64, gnutls.x86_64, gobject-introspection.x86_64, gpgme.x86_64,
grep.x86_64, groff-base.x86_64, grub2-tools.x86_64, grub2.x86_64,
grubby.x86_64, gsettings-desktop-schemas.x86_64, gzip.x86_64, hardlink.x86_64,
hostname.x86_64, hwdata.noarch, info.x86_64, initscripts.x86_64,
iproute.x86_64, iprutils.x86_64, iptables.x86_64, iputils.x86_64,
irqbalance.x86_64, iwl100-firmware.noarch, iwl1000-firmware.noarch,
iwl105-firmware.noarch, iwl135-firmware.noarch, iwl2000-firmware.noarch,
iwl2030-firmware.noarch, iwl3160-firmware.noarch, iwl3945-firmware.noarch,
iwl4965-firmware.noarch, iwl5000-firmware.noarch, iwl5150-firmware.noarch,
iwl6000-firmware.noarch, iwl6000g2a-firmware.noarch,
iwl6000g2b-firmware.noarch, iwl6050-firmware.noarch, iwl7260-firmware.noarch,
jansson.x86_64, json-c.x86_64, kbd-misc.noarch, kbd.x86_64,
kernel-devel.x86_64, kernel-headers.x86_64, kernel-tools-libs.x86_64,
kernel-tools.x86_64, kernel.x86_64, kexec-tools.x86_64, keyutils-libs.x86_64,
keyutils.x86_64, kmod-libs.x86_64, kmod.x86_64, kpartx.x86_64,
krb5-libs.x86_64, less.x86_64, libacl.x86_64, libassuan.x86_64, libattr.x86_64,
libblkid.x86_64, libcap-ng.x86_64, libcap.x86_64, libcom_err.x86_64,
libcroco.x86_64, libcurl.x86_64, libdaemon.x86_64, libdb-utils.x86_64,
libdb.x86_64, libdrm.x86_64, libedit.x86_64, libertas-sd8686-firmware.noarch,
libertas-sd8787-firmware.noarch, libertas-usb8388-firmware.noarch,
libestr.x86_64, libevent.x86_64, libffi.x86_64, libgcc.x86_64,
libgcrypt.x86_64, libgomp.x86_64, libgpg-error.x86_64, libgudev1.x86_64,
libidn.x86_64, libmnl.x86_64, libmodman.x86_64, libmount.x86_64, libmpc.x86_64,
libndp.x86_64, libnetfilter_conntrack.x86_64, libnfnetlink.x86_64,
libnfsidmap.x86_64, libnl3-cli.x86_64, libnl3.x86_64, libpcap.x86_64,
libpciaccess.x86_64, libpipeline.x86_64, libproxy.x86_64, libpwquality.x86_64,
libselinux-python.x86_64, libselinux-utils.x86_64, libselinux.x86_64,
libsemanage.x86_64, libsepol.x86_64, libsoup.x86_64, libss.x86_64,
libssh2.x86_64, libstdc++.x86_64, libsysfs.x86_64, libtasn1.x86_64,
libteam.x86_64, libtirpc.x86_64, libunistring.x86_64, libuser.x86_64,
libutempter.x86_64, libuuid.x86_64, libverto.x86_64, libxml2.x86_64,
linux-firmware.noarch, logrotate.x86_64, lua.x86_64, lvm2-libs.x86_64,
lvm2.x86_64, lzo.x86_64, make.x86_64, man-db.x86_64, mariadb-libs.x86_64,
microcode_ctl.x86_64, mozjs17.x86_64, mpfr.x86_64, ncurses-base.noarch,
ncurses-libs.x86_64, ncurses.x86_64, net-tools.x86_64, nettle.x86_64,
newt-python.x86_64, newt.x86_64, nfs-utils.x86_64, nspr.x86_64,
nss-softokn-freebl.x86_64, nss-softokn.x86_64, nss-sysinit.x86_64,
nss-tools.x86_64, nss-util.x86_64, nss.x86_64, numactl-libs.x86_64,
openldap.x86_64, openssh-clients.x86_64, openssh-server.x86_64, openssh.x86_64,
openssl-libs.x86_64, openssl.x86_64, os-prober.x86_64, p11-kit-trust.x86_64,
p11-kit.x86_64, pam.x86_64, parted.x86_64, passwd.x86_64, patch.x86_64,
pciutils-libs.x86_64, pcre.x86_64, perl-Carp.noarch, perl-Encode.x86_64,
perl-Exporter.noarch, perl-File-Path.noarch, perl-File-Temp.noarch,
perl-Filter.x86_64, perl-Getopt-Long.noarch, perl-HTTP-Tiny.noarch,
perl-PathTools.x86_64, perl-Pod-Escapes.noarch, perl-Pod-Perldoc.noarch,
perl-Pod-Simple.noarch, perl-Pod-Usage.noarch, perl-Scalar-List-Utils.x86_64,
perl-Socket.x86_64, perl-Storable.x86_64, perl-Text-ParseWords.noarch,
perl-Time-Local.noarch, perl-constant.noarch, perl-libs.x86_64,
perl-macros.x86_64, perl-parent.noarch, perl-podlators.noarch,
perl-threads-shared.x86_64, perl-threads.x86_64, perl.x86_64, pinentry.x86_64,
pkgconfig.x86_64, plymouth-core-libs.x86_64, plymouth-scripts.x86_64,
plymouth.x86_64, policycoreutils.x86_64, polkit-pkla-compat.x86_64,
polkit.x86_64, popt.x86_64, postfix.x86_64, ppp.x86_64, procps-ng.x86_64,
pth.x86_64, pygobject3-base.x86_64, pygpgme.x86_64, pyliblzma.x86_64,
python-backports-ssl_match_hostname.noarch, python-backports.noarch,
python-configobj.noarch, python-decorator.noarch, python-iniparse.noarch,
python-libs.x86_64, python-pycurl.x86_64, python-pyudev.noarch,
python-setuptools.noarch, python-slip-dbus.noarch, python-slip.noarch,
python-urlgrabber.noarch, python.x86_64, pyxattr.x86_64, qrencode-libs.x86_64,
quota-nls.noarch, quota.x86_64, readline.x86_64, rootfiles.noarch,
rpcbind.x86_64, rpm-build-libs.x86_64, rpm-libs.x86_64, rpm-python.x86_64,
rpm.x86_64, rsyslog.x86_64, sed.x86_64, selinux-policy-targeted.noarch,
selinux-policy.noarch, setup.noarch, shadow-utils.x86_64,
shared-mime-info.x86_64, slang.x86_64, snappy.x86_64, sqlite.x86_64,
sudo.x86_64, systemd-libs.x86_64, systemd-sysv.x86_64, systemd.x86_64,
sysvinit-tools.x86_64, tar.x86_64, tcp_wrappers-libs.x86_64,
tcp_wrappers.x86_64, teamd.x86_64, tuned.noarch, tzdata.noarch, ustr.x86_64,
util-linux.x86_64, vim-minimal.x86_64, virt-what.x86_64, wget.x86_64,
which.x86_64, wpa_supplicant.x86_64, xfsprogs.x86_64, xz-libs.x86_64,
xz.x86_64, yum-metadata-parser.x86_64, yum-plugin-fastestmirror.noarch,
yum.noarch, zlib.x86_64, ModemManager-glib.x86_64, NetworkManager-glib.x86_64,
NetworkManager-tui.x86_64, NetworkManager.x86_64

Added CentOS Packages
---------------------
apr-util.x86_64, apr.x86_64, atk.x86_64, autogen-libopts.x86_64, c-ares.x86_64,
cairo.x86_64, cpp.x86_64, cups-libs.x86_64, fontconfig.x86_64,
fontpackages-filesystem.noarch, freetype-devel.x86_64, freetype.x86_64,
gcc-c++.x86_64, gcc.x86_64, gd.x86_64, gdk-pixbuf2.x86_64,
ghostscript-fonts.noarch, ghostscript.x86_64, git.x86_64, gpm-libs.x86_64,
graphite2.x86_64, graphviz.x86_64, gtk2.x86_64, harfbuzz.x86_64,
hicolor-icon-theme.noarch, httpd-tools.x86_64, httpd.x86_64,
jasper-libs.x86_64, jbigkit-libs.x86_64, lcms2.x86_64, libICE.x86_64,
libSM.x86_64, libX11-common.noarch, libX11.x86_64, libXau.x86_64,
libXaw.x86_64, libXcomposite.x86_64, libXcursor.x86_64, libXdamage.x86_64,
libXext.x86_64, libXfixes.x86_64, libXfont.x86_64, libXft.x86_64, libXi.x86_64,
libXinerama.x86_64, libXmu.x86_64, libXpm.x86_64, libXrandr.x86_64,
libXrender.x86_64, libXt.x86_64, libXxf86vm.x86_64, libfontenc.x86_64,
libgcc.x86_64, libgnome-keyring.x86_64, libgomp.x86_64, libjpeg-turbo.x86_64,
libpng-devel.x86_64, libpng.x86_64, librsvg2.x86_64, libsmi.x86_64,
libstdc++-devel.x86_64, libstdc++.x86_64, libthai.x86_64, libtiff.x86_64,
libtool-ltdl.x86_64, libxcb.x86_64, libxslt.x86_64, lm_sensors-libs.x86_64,
mailcap.noarch, mesa-libEGL.x86_64, mesa-libGL.x86_64, mesa-libgbm.x86_64,
mesa-libglapi.x86_64, mod_ssl.x86_64, mod_wsgi.x86_64, ncurses-devel.x86_64,
net-snmp-agent-libs.x86_64, net-snmp-libs.x86_64, net-snmp.x86_64, ntp.x86_64,
ntpdate.x86_64, openssl-libs.x86_64, openssl.x86_64, pango.x86_64,
perl-Data-Dumper.x86_64, perl-Error.noarch, perl-Git.noarch,
perl-TermReadKey.x86_64, pixman.x86_64, poppler-data.noarch,
postgresql-contrib.x86_64, postgresql-devel.x86_64, postgresql-libs.x86_64,
postgresql-server.x86_64, postgresql.x86_64, python-chardet.noarch,
python-devel.x86_64, python-kitchen.noarch, python-libs.x86_64, python.x86_64,
rsync.x86_64, sqlite-devel.x86_64, tree.x86_64, unzip.x86_64, urw-fonts.noarch,
uuid.x86_64, vim-common.x86_64, vim-enhanced.x86_64, vim-filesystem.x86_64,
wireshark.x86_64, xorg-x11-font-utils.x86_64, yum-utils.noarch, yum.noarch,
zlib-devel.x86_64, zsh.x86_64

Python Packages (with version numbers)
--------------------------------------
alabaster==0.7.6,
amqp==1.4.6,
aniso8601==1.0.0,
ansi2html==1.1.0,
anyjson==0.3.3,
appnope==0.1.0,
APScheduler==3.0.3,
Babel==2.0,
backports.ssl-match-hostname==3.4.0.2,
billiard==3.3.0.20,
celery==3.1.18,
certifi==2015.4.28,
decorator==4.0.2,
Django==1.7.9,
django-ace==1.0.2,
django-admin-tools==0.5.2,
django-celery==3.1.16,
django-extensions==1.4.6,
django-model-utils==2.0.3,
djangorestframework==2.3.13,
djangorestframework-csv==1.3.3,
docutils==0.12,
ecdsa==0.13,
Flask==0.10.1,
Flask-RESTful==0.3.2,
flower==0.8.3,
funcsigs==0.4,
functools32==3.2.3.post2,
futures==3.0.3,
gnureadline==6.3.3,
graphviz==0.4.6,
importlib==1.0.3,
ipaddress==1.0.14,
ipykernel==4.0.3,
ipyparallel==4.0.0,
ipython==4.0.0,
ipython-genutils==0.1.0,
itsdangerous==0.24,
Jinja2==2.8,
jsonfield==0.9.20,
jsonschema==2.5.1,
jupyter-client==4.0.0,
jupyter-core==4.0.2,
kombu==3.0.26,
MarkupSafe==0.23,
matplotlib==1.4.3,
mistune==0.7,
mock==1.3.0,
nbconvert==4.0.0,
nbformat==4.0.0,
netaddr==0.7.15,
nose==1.3.7,
notebook==4.0.1,
numpy==1.9.2,
numpydoc==0.5,
pandas==0.15.2,
paramiko==1.15.2,
path.py==7.6,
pbr==1.4.0,
pexpect==3.3,
pickleshare==0.5,
psycopg2==2.6.1,
ptyprocess==0.5,
pycrypto==2.6.1,
pygeoip==0.3.2,
Pygments==2.0.2,
pyparsing==2.0.3,
pyreadline==2.0,
python-dateutil==2.4.2,
pytz==2015.4,
pyzmq==14.7.0,
qtconsole==4.0.0,
redis==2.10.3,
requests==2.4.3,
scp==0.10.2,
simplegeneric==0.8.1,
six==1.9.0,
snowballstemmer==1.2.0,
Sphinx==1.3.1,
sphinx-rtd-theme==0.1.8,
terminado==0.5,
testpath==0.2,
tornado==4.2.1,
traitlets==4.0.0,
tzlocal==1.2,
Werkzeug==0.10.4,
wheel==0.24.0
