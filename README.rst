SteelScript VM Config
=====================

Command-line Python Development Environment with SteelScript


Requirements
------------

* `VirtualBox <http://www.virtualbox.org/>`_
* `Vagrant <http://www.vagrantup.com/>`_ - version 1.6.2 or later
* `Ansible <http://www.ansibleworks.com>`_ - version 1.3.4 or later
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

2. Clone this repo via the following command, or using one of the Github GUI
   clients, click the button: Clone in {platform}:

.. code-block:: console

        $ git clone https://github.com/riverbed/steelscript-vm-config.git

3. Navigate into the new repo:

.. code-block:: console

        $ cd steelscript-vm-config (Wherever your cloned path is for this repo)

4. If using Windows, run the ``vmconfig.bat`` file in this directory.  This just copies
   ``Vagrantfile.win`` to ``Vagrantfile``.

5. Install the vagrant plugin 'vagrant-vbguest'.

.. code-block:: console

        $ vagrant plugin install vagrant-vbguest

5. Provision a new Vagrant VM:

.. code-block:: console

        $ vagrant up

6. A fresh install will take between 10-20 minutes depending on your internet connection.

7. Once completed, a new virtual machine will be waiting with SteelScript
   Application Framework and IPython Notebooks ready.


SteelScript Application Framework
---------------------------------

1. On your host machine, head to the URL
   `http://127.0.0.1:30080 <http://127.0.0.1:30080>`_ and the portal should
   appear!
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
                          debugging VM or Portal issues.
========================= ==========================================================================

For further information, see the following descriptions about Portal and how to
customize it:

    `Introducing the FlyScript Portal <https://splash.riverbed.com/docs/DOC-1765>`_
    `SteelScript App Framework on GitHub <https://github.com/riverbed/steelscript-app-fmwk>`_


IPython Notebooks
-----------------

1. Once installed, login to the machine, and start a fresh IPython notebook instance:

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
        vagrant@precise32:/usr/local/share/doc/ipython/examples/notebooks$ ipython notebook --ip=`facter ipaddress` --pylab=inline
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

