## DESCRIPTION

Command-line Python Development Environment with FlyScript


## REQUIREMENTS

* [VirtualBox](http://www.virtualbox.org/)
* [VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](http://www.vagrantup.com/)
* [git](http://git-scm.com/downloads)
or one of the Github GUI clients: [OSX](http://mac.github.com/), [Windows] (http://windows.github.com/), [Eclipse](http://eclipse.github.com/)

        Clone this repo: $ git clone git@github.com:riverbed/flyscript-vm.git
        Or, using one of the Github GUI clients, click the button: Clone in {platform}

## BASIC USAGE

1. Assuming you have met the above requirements. 
2. Provision a new Vagrant VM (using FlyscriptVM as example):

        $ vagrant box add FlyscriptVM http://files.vagrantup.com/precise32.box
        $ cd flyscript-vm (Wherever your cloned path is for this repo)
        $ vagrant up

3. A fresh install will take between 10-20 minutes depending on your internet connection.
4. Once completed, a fresh virtual machine will be waiting with FlyScript Portal and IPython Notebooks ready.


### FlyScript Portal

1. On your host machine, head to the URL [http://127.0.0.1:30080](http://127.0.0.1:30080) and the portal should appear!
2. You will see a page with form fields for a profiler and shark appliance, fill out the IP address/port and Username/Password for each appliance
3. Click the "Reports" button on the navigation bar, and run a report!

To customize the reports that are available and take a peek under the hood, you can ssh directly into the VM and look at each of the report files:

        $ vagrant ssh
        vagrant@precise32:~$ cd /flyscript/flyscript_portal/config/reports

For further information, see the following descriptions about Portal and how to customize it:

    [Introducing the FlyScript Portal](https://splash.riverbed.com/docs/DOC-1765)
    [FlyScript Portal on GitHub](https://github.com/riverbed/flyscript-portal)


### IPython Notebooks

1. Once installed, login to the machine, and start a fresh IPython notebook instance:

        $ vagrant ssh
        vagrant@precise32:~$ ipython notebook --ip=`facter ipaddress` --pylab=inline
        [NotebookApp] Created profile dir: u'/home/vagrant/.ipython/profile_default'
        [NotebookApp] Serving notebooks from /home/vagrant
        [NotebookApp] The IPython Notebook is running at: http://<ipaddress>:8888/
        [NotebookApp] Use Control-C to stop this server and shut down all kernels.
        [NotebookApp] No web browser found: could not locate runnable browser.

2. On a browser on the host machine, head to the following url: [http://127.0.0.1:38888](http://127.0.0.1:38888).
3. A notebook instance should be visible.
4. Any notebooks created, will be saved to the directory where the command was started from.  In the example above, this would be the home directory for the user `vagrant` (the default user for new virtual machines).  
5. For a more in depth introduction to IPython notebooks, there are several examples included in the documentation:

        vagrant@precise32:~$ cd /usr/local/share/doc/ipython/examples/notebooks
        vagrant@precise32:/usr/local/share/doc/ipython/examples/notebooks$ ipython notebook --ip=`facter ipaddress` --pylab=inline
        [NotebookApp] Using existing profile dir: u'/home/vagrant/.ipython/profile_default'
        [NotebookApp] Serving notebooks from /usr/local/share/doc/ipython/examples/notebooks
        [NotebookApp] The IPython Notebook is running at: http://10.0.2.15:8888/
        [NotebookApp] Use Control-C to stop this server and shut down all kernels.
        [NotebookApp] No web browser found: could not locate runnable browser.

6. Now opening the same URL as in step 2 will show several pre-generated example scripts you can walk through. You won't be able to save changes here, but that should make experimentation a little easier too.

Note: this notebook will be accessible to anyone on your LAN, if additional security is required, learn 
more about adding passwords and encryption [here in the documentation](http://ipython.org/ipython-doc/dev/interactive/htmlnotebook.html#security).

