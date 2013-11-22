## DESCRIPTION

Command-line Python Development Environment with FlyScript


## REQUIREMENTS

* [VirtualBox](http://www.virtualbox.org/)
* [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://www.vagrantup.com/) - version 1.3.5 or later
* [Ansible](http://www.ansibleworks.com) - version 1.3.4 or later
* [git](http://git-scm.com/downloads)
or one of the Github GUI clients: [OSX](http://mac.github.com/), [Windows] (http://windows.github.com/), [Eclipse](http://eclipse.github.com/)

        Clone this repo: $ git clone git@github.com:riverbed/flyscript-vm.git
        Or, using one of the Github GUI clients, click the button: Clone in {platform}

## BASIC USAGE

1. Verify you have met the above requirements. Ansible is simply a python
   library, and can usually be installed via 'pip install ansible'.  The other
   packages require system-level installations.
2. Provision a new Vagrant VM:

        $ cd flyscript-vm (Wherever your cloned path is for this repo)
        $ vagrant up

3. A fresh install will take between 10-20 minutes depending on your internet connection.
4. Once completed, a fresh virtual machine will be waiting with FlyScript
   Portal and IPython Notebooks ready.


### FlyScript Portal

1. On your host machine, head to the URL
   [http://127.0.0.1:30080](http://127.0.0.1:30080) and the portal should
   appear!
2. You will see a page with form fields for a profiler and shark appliance,
   fill out the IP address/port and Username/Password for each appliance
3. Click the "Reports" button on the navigation bar, and run a report!

To customize the reports that are available and take a peek under the hood, you
can ssh directly into the VM and look at each of the report files:

        $ vagrant ssh
        vagrant@precise32:~$ cd /flyscript/flyscript_portal/config/reports

The VM has Portal installed in two locations now, a 'staging' or development
area, and a 'deployed' or production area.  There are now helper scripts and
aliases to ease the process of moving changes from 'staging' over to 'deployed'
versus the somewhat arcane approach in previous releases.

Changes and edits can now easily be made in the staging area without the need for
sudo'ing or worrying about permissions. When ready to publish changes to the
deployed area, the run the alias `deploy` and the sequence of operations will 
push the changes and update the server instance.

A summary of included aliases and commands:

Aliases / Functions |  Description                                                            |
-----------------|:------------------------------------------------------------------------|
`portal_view_err_log`   |  show the apache error log
`portal_view_access_log`|  show the apache access log
`portal_view_portal_log`|  show the portal debug log
`cdportal`       |  shortcut to `cd /flyscript/flyscript_portal`, the staging directory
`cdwww`          |  shortcut to `cd /var/www`, the deployed directory
`cdshared`       |  shortcut to `cd /vagrant`, the shared directory with the host machine.
                 |  This can be a convenient way to share files between the guest and host.
`run_ipython_notebooks` | shortcut to run ipython notebook server (documented below) |
`portal_dev_server`     | shortcut to run the django development server in the staging directory
`portal_update`  | pull the latest changes from github and merge them into the 
                 | staging directory.  If you have made changes already, you may need
                 | to run `git stash` before this command.  After it completes, run `git pop` 
                 | to have your changes re-applied.
`portal_deploy`  | push changes from the staging area to the webserver.
`portal_reset_www`    | runs a `clean --reset` on the deployed directory.  Helpful for 
                      | troubleshooting especially if the DB gets out of sync.
`portal_collect_logs` | collects and zips up all the appropriate logs to help with 
                      | debugging VM or Portal issues.

For further information, see the following descriptions about Portal and how to
customize it:

    [Introducing the FlyScript Portal](https://splash.riverbed.com/docs/DOC-1765)
    [FlyScript Portal on GitHub](https://github.com/riverbed/flyscript-portal)


### IPython Notebooks

1. Once installed, login to the machine, and start a fresh IPython notebook instance:

        $ vagrant ssh
        vagrant@precise32:~$ run_ipython_notebook
        [NotebookApp] Created profile dir: u'/home/vagrant/.ipython/profile_default'
        [NotebookApp] Serving notebooks from /home/vagrant
        [NotebookApp] The IPython Notebook is running at: http://<ipaddress>:8888/
        [NotebookApp] Use Control-C to stop this server and shut down all kernels.
        [NotebookApp] No web browser found: could not locate runnable browser.

2. On a browser on the host machine, head to the following url:
   [http://127.0.0.1:38888](http://127.0.0.1:38888).
3. A notebook instance should be visible.
4. Any notebooks created, will be saved to the directory where the command was
   started from.  In the example above, this would be the home directory for
   the user `vagrant` (the default user for new virtual machines).  
5. For a more in depth introduction to IPython notebooks, there are several
   examples included in the documentation:

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
[here in the documentation](http://ipython.org/ipython-doc/dev/interactive/htmlnotebook.html#security).

