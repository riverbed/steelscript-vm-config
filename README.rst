SteelScript VM Config
=====================

Command-line Python Development Environment with SteelScript



Introduction
------------

This document describes how to build your own SteelScript Virtual Machine
using pre-defined templates and helpful automation tools.


Requirements
------------

* `VirtualBox <http://www.virtualbox.org/>`_
* `Vagrant <http://www.vagrantup.com/>`_ - version 1.7.2 or later
* `Ansible <http://www.ansibleworks.com>`_ - version 1.9.2 or later
* `git <http://git-scm.com/downloads>`_

Installation
------------

1. Verify you have met the above requirements. Ansible is simply a python
   library, and can usually be installed via ``pip install ansible``.  The other
   packages require system-level installations.

   **Windows users note 1**: You will need to run the commands from the Git Bash
   or Cygwin command shell.  Git Bash should be included as part of the
   installation package in the `git <http://git-scm.com/downloads>`_ download.

   **Windows users note 2**: When using Windows as the host machine, the ansible package
   is not yet fully supported and will fail when trying to ``pip install`` it. An extra
   step is included in Step 4 to workaround this.

2. Clone this repo using one of the Github GUI clients, or by clicking the 
   button in the github project page labeled ``Clone in Desktop``, 
   or via the following CLI command:

.. code-block:: console

        $ git clone https://github.com/riverbed/steelscript-vm-config.git

3. Navigate into the new repo:

.. code-block:: console

        $ cd steelscript-vm-config (Wherever your cloned path is for this repo)

4. If using Windows, run the ``vmconfig.bat`` file in this directory.  This just copies
   ``Vagrantfile.win`` to ``Vagrantfile``.

5. Provision a new Vagrant VM:

.. code-block:: console

        $ vagrant up

6. A fresh install will take between 20-30 minutes depending on your internet connection.

7. Once completed, a new virtual machine will be waiting with SteelScript
   Application Framework and IPython Notebooks ready.


Usage and Configuration
-----------------------

`See the usage document <https://support.riverbed.com/apis/steelscript/vmconfig/usage.html>`_
for a description of the layout and configuration of the SteelScript VM along with important
security considerations should you deploy this VM within your network.

