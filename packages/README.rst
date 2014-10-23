Source Package Download
=======================

The `packages` directory contains helper scripts to download
the sources for all installed packages on the virtual machine.

As part of the initial VM provisioning process, two snapshots are
taken of the installed packages, first the snapshot of all files
from our base linux image, and second once we have installed
everything additional.  The results of these two snapshots are
captured here:

    - packages/installed_pkgs_pre_provision.txt
    - packages/installed_pkgs_post_provision.txt

These files will only be written once, since subsequent
provisions will end up creating the same package lists.

To download all of the sources yourself, copy the whole
`packages` directory somewhere into the vm filesystem::

    $ cd /usr/src/
    $ sudo mkdir image-sources
    $ sudo chown vagrant:vagrant image-sources
    $ cd image-sources
    $ cp -r /vagrant/packages/* .

Next, download all of the packages with the following script::

    $ ./download_source_packages.sh

Three new folders will be available:

    - sources-base-packages:  source packages from base linux image
    - sources-added-packages: source packages installed during provisioning
    - sources-python-pacakges: source python packages installed into the virtualenv

Logs of the download process will be shown as well which
could be searched for any errors during the download process.
